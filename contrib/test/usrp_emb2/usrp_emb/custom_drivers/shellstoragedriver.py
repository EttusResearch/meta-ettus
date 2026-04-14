import enum
import os
import time
import subprocess

import attr

from labgrid.factory import target_factory
from labgrid.step import step
from labgrid.util.managedfile import ManagedFile
from labgrid.driver.common import Driver
from labgrid.driver.exception import ExecutionError
from labgrid.driver.usbstoragedriver import Mode

from labgrid.util.helper import processwrapper
from labgrid.util import Timeout


@target_factory.reg_driver
@attr.s(eq=False)
class ShellStorageDriver(Driver):
    bindings = {
        "shell": {
            "ShellDriver",
        },
        "http": {
            "HTTPProviderDriver",
        }
    }
    image = attr.ib(
        default=None,
        validator=attr.validators.optional(attr.validators.instance_of(str))
    )
    block_name = attr.ib(
        default="mmcblk0",
        validator=attr.validators.optional(attr.validators.instance_of(str))
    )
    timeout = attr.ib(
        default=120,
        validator=attr.validators.optional(attr.validators.instance_of(int))
    )

    def on_activate(self):
        pass

    def on_deactivate(self):
        pass

    @Driver.check_active
    @step(args=['filename'])
    def write_image(self, filename=None, mode=Mode.DD, partition=None, skip=0, seek=0):
        """
        Writes the file specified by filename or if not specified by config image subkey to the
        bound USB storage root device or partition.

        Args:
            filename (str): optional, path to the image to write to bound USB storage
            mode (Mode): optional, Mode.DD or Mode.BMAPTOOL (defaults to Mode.DD)
            partition (int or None): optional, write to the specified partition or None for writing
                to root device (defaults to None)
            skip (int): optional, skip n 512-sized blocks at start of input file (defaults to 0)
            seek (int): optional, skip n 512-sized blocks at start of output (defaults to 0)
        """
        if filename is None and self.image is not None:
            filename = self.target.env.config.get_image_path(self.image)
        assert filename, "write_image requires a filename"
        remote_path = self.http.stage(filename)

        # wait for medium
        timeout = Timeout(10.0)
        while not timeout.expired:
            try:
                if self.get_size() > 0:
                    break
                time.sleep(0.5)
            except ValueError:
                # when the medium gets ready the sysfs attribute is empty for a short time span
                continue
        else:
            raise ExecutionError("Timeout while waiting for medium")

        if partition is None:
            target = f"/dev/{self.block_name}"
        else:
            target = f"/dev/{self.block_name}p{partition}"

        if mode == Mode.DD:
            raise NotImplementedError("flashing with DD mode is not yet implemented")
            self.logger.info('Writing %s to %s using dd.', remote_path, target)
            block_size = '512' if skip or seek else '4M'
            args = [
                "dd",
                f"if={remote_path}",
                f"of={target}",
                "oflag=direct",
                "status=progress",
                f"bs={block_size}",
                f"skip={skip}",
                f"seek={seek}",
                "conv=fdatasync"
            ]
        elif mode == Mode.BMAPTOOL:
            if skip or seek:
                raise ExecutionError("bmaptool does not support skip or seek")

            # Try to find a block map file using the same logic that bmaptool
            # uses. Handles cases where the image is named like: <image>.bz2
            # and the block map file is <image>.bmap
            remote_path_bmap = None
            image_path = filename
            while True:
                bmap_path = f"{image_path}.bmap"
                if os.path.exists(bmap_path):
                    remote_path_bmap = self.http.stage(bmap_path)
                    break

                image_path, ext = os.path.splitext(image_path)
                if not ext:
                    break

            self.logger.info('Writing %s to %s using bmaptool.', remote_path, target)
            args = [
                "bmaptool",
                "copy",
                f"{remote_path}",
                f"{target}",
            ]

            if remote_path_bmap is None:
                args.append("--nobmap")
            else:
                args.append(f"--bmap={remote_path_bmap}")
        else:
            raise ValueError

        # processwrapper.check_output(
        #     args,
        #     print_on_silent_log=True
        # )

        self.shell.run(' '.join(args), timeout=self.timeout)

    @Driver.check_active
    @step(result=True)
    def get_size(self):
        args = ["cat", f"/sys/class/block/{self.block_name}/size"]
        size = self.shell.run(' '.join(args))[0][0]
        return int(size)*512
