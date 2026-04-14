import argparse
import logging
import os.path
import re
import subprocess
import shlex
import sys
import tempfile
import time

from .custom_drivers.chromiumecdriver import ChromiumEcPowerDriver

from .httpd import HTTPServer
from .tftp import TFTPServer

from labgrid.driver.shelldriver import gen_marker
from labgrid.environment import Environment
from labgrid.logging import basicConfig, StepLogger
from labgrid.target import Target
from mako.template import Template
from pathlib import Path
from pexpect.exceptions import TIMEOUT

usrp_types = ["e310_sg1", "e310_sg3", "e320", "n3xx", "x4xx"]

def update_ipk(target: Target, args):
    raise NotImplementedError()


def update_mender(target: Target, args):
    raise NotImplementedError()


def power_cycle(target: Target):
    print("Power cycling DUT", flush=True)
    power = target.get_driver("ChromiumEcPowerDriver")
    power.cycle()


def boot_linux(target: Target):
    serial = target.get_driver("SerialDriver", name="ps_console")

    print("Waiting for U-Boot", flush=True)
    serial.expect("U-Boot SPL [0-9.]+")
    serial.expect("U-Boot [0-9.]+")
    index, _, match, _ = serial.expect(["Starting kernel", "ERROR: can't get kernel image!"])
    if index == 1:
        raise RuntimeError(match.group(0))

    print("Booting Linux", flush=True)
    target.get_driver("ShellDriver")


def transition_to_linux(target: Target):
    serial = target.get_driver("SerialDriver", name="ps_console")
    linux = target.get_driver("ShellDriver", activate=False)
    serial.sendline("")
    index, _, _, _ = serial.expect([linux.prompt, TIMEOUT], timeout=2)
    if index == 1:
        power_cycle(target)
        boot_linux(target)


def netboot(target: Target, fitimage: Path):
    print("Waiting for U-Boot", flush=True)
    uboot = target.get_driver("UBootDriver")

    print("Waiting for NIC to come up", flush=True)
    index, _, _, _ = uboot.console.expect([TIMEOUT, "Debug uart enabled"], timeout=8)
    if index == 1:
        raise RuntimeError("U-Boot restarted by itself, probably triggered by a watchdog event")

    print("Checking DHCP address", flush=True)
    dhcp_result = uboot.run("dhcp")
    dhcp_pattern = re.compile(r"^DHCP client bound to address (\d+\.\d+\.\d+\.\d+)")
    target_ip = None
    for line in dhcp_result[0]:
        match = dhcp_pattern.match(line)
        if match:
            target_ip = match.group(1)
            print(match.group(0), flush=True)
            break
    with TFTPServer(fitimage, target_ip) as server:
        for cmd in [f"setenv serverip {server.ip}",\
                    f"setenv tftpdstp {server.port}",\
                    'setenv tftproot ""',\
                    f"setenv fit_image {fitimage.name}",\
                    'setenv netargs "printenv serverip && printenv tftproot"']:
            stdout, stderr, rc = uboot.run(cmd)
            print(f"[uboot] {cmd} -> retcode={rc}, out={stdout}, err={stderr}", flush=True)
        uboot.console.logfile_read = sys.stdout.buffer
        uboot.console.sendline("run netboot")
        index, before, match, _ = uboot.console.expect([TIMEOUT, "Starting kernel", "ERROR: can't get kernel image!"], timeout=30)
        #with open("./output.txt", "wb") as console_out_fp:
        #    console_out_fp.write(before)
        uboot.console.logfile_read = None
        #boot_output = before.decode('utf-8', errors='replace').replace('\r', '').splitlines()
        if index == 0:
            raise RuntimeError("Timeout waiting for kernel boot after 'run netboot'")
        if index == 2:
            raise RuntimeError(match.group(0))
    print("Booting Linux", flush=True)
    target.get_driver("ShellDriver")


def get_ip_addr(target: Target, iface: str = "eth0", timeout=5):
    linux = target.get_driver("ShellDriver")
    start_time = time.time()
    while True:
        addresses = linux.get_ip_addresses(iface)
        if len(addresses) > 0:
            return str(addresses[0].ip)
        elif time.time() - start_time > timeout:
            raise RuntimeError(f"Could not get IP address for interface {iface} within {timeout} seconds")
        else:
            time.sleep(1)

def image_is_on_server(image: str):
    return any([image.startswith(x) for x in ["ftp://", "http://", "https://"]])


def update_sdimg(target: Target, args, timeout=900):
    logger = logging.getLogger("update_sdimg")

    def run_bmaptool(target: Target, image_url: str):
        start_time = time.time()
        target_device = "/dev/mmcblk0"
        logger.info(f"Writing SD card using {image_url} to {target_device}")
        logger.info("Running bmaptool... This will take a while")
        marker = gen_marker()
        cmd = f"bmaptool copy {image_url} {target_device}"
        cmp_command = f'''MARKER='{marker[:4]}''{marker[4:]}' run {shlex.quote(cmd)}'''
        linux.console.sendline(cmp_command)
        linux.console.expect(rf"{marker}")
        while True:
            index, _, match, _ = linux.console.expect([rf"{marker}\s+(\d+)\s+{linux.prompt}", "bmaptool: Syncing...", "bmaptool: [^\n]+"], timeout=120)
            if index == 0:
                break
            else:
                logger.info(match.group(0).decode()[:-1])
                if time.time() - start_time > timeout:
                    raise RuntimeError("Timeout waiting for bmaptool to finish")

    power_cycle(target)
    netboot(target, Path(args.fitimage))

    linux = target.get_driver("ShellDriver")
    target_ip = get_ip_addr(target)

    if not image_is_on_server(args.image):
        image = Path(args.image)
        with HTTPServer(image.parent, target_ip) as server:
            run_bmaptool(target, server.get_url(image.name))
    else:
        run_bmaptool(target, args.image)

    logger.info("Rebooting into new image from SD card")
    linux.console.sendline("reboot")
    linux.console.expect("reboot: Restarting system")
    target.deactivate(linux)

    boot_linux(target)
    target_ip = get_ip_addr(target)

    known_hosts_path = os.path.expanduser("~/.ssh/known_hosts")
    subprocess.run(
        args=shlex.split(f'ssh-keygen -f "{known_hosts_path}" -R "{target_ip}"'), check=False
    )
    print(f"Successfully updated SD card image of the device (IP: {target_ip})")

def run_command(target: Target, command: str, timeout=30.0, logger: logging.Logger = None):
    linux = target.get_driver("ShellDriver")
    if logger is None:
        logger = linux.logger
    logger.info(f"Running command: {command}")
    stdout, stderr, returncode = linux.run(command, timeout=timeout)
    if len(stdout) > 0:
        logger.info("*** stdout begin ***")
        [logger.info(line) for line in stdout]
        logger.info("*** stdout end ***")
    if len(stderr) > 0:
        logger.warning("*** stderr begin ***")
        [logger.warning(line) for line in stderr]
        logger.warning("*** stderr end ***")
    return returncode


def update_packages(target: Target, args):
    logger = logging.getLogger("update_packages")

    assert Path(args.packages_dir).exists, f"Error: Packages directory {args.packages_dir} does not exist"
    subdirs = [x.name for x in Path(args.packages_dir).iterdir() if x.is_dir()]
    available_packages = {}
    for subdir in subdirs:
        with open(Path(args.packages_dir, subdir, "Packages")) as f:
            name = None
            version = None
            for line in f.readlines():
                if line.startswith("Package: "):
                    name = line[9:-1]
                    available_packages[name] = None
                elif line.startswith("Version: "):
                    version = line[9:-1]
                    available_packages[name] = version
                    name = None
                    version = None
    if len(args.package) > 0:
        packages = args.package
    else:
        packages = list(available_packages.keys())
    available_str = " ".join([f"{k}={v}" for k, v in available_packages.items()])
    logger.info(f"installing packages from directory {args.packages_dir}")
    logger.info(f"available architectures: {' '.join(subdirs)}")
    logger.info(f"available packages: {available_str}")
    logger.info(f"packages to be installed: {' '.join(packages)}")
    missing_packages = list(set(packages) - set(available_packages.keys()))
    if len(missing_packages) > 0:
        raise RuntimeError(f"The followinging packages cannot be installed: {' '.join(missing_packages)}")
    transition_to_linux(target)
    linux = target.get_driver("ShellDriver")
    target_ip = get_ip_addr(target)
    logger.info(f"connected to target {target_ip}")
    with HTTPServer(args.packages_dir, target_ip) as server:
        conf = "/etc/opkg/feeds.conf"
        backup = "/etc/opkg/feeds.conf.bak"
        linux.run(f"if [ -e {conf} ]; then mv {conf} {backup}; fi")
        linux.run(f"echo '' > {conf}")
        for subdir in subdirs:
            linux.run(f"echo 'src/gz uri-{subdir} {server.get_url(subdir)}' >> {conf}")
        returncode = run_command(target, "opkg update", logger=logger)
        assert returncode == 0, f"Error: opkg update failed with return code {returncode}"
        packages_installed = " ".join([f"{k}={v}" for k, v in available_packages.items() if k in packages])
        returncode = run_command(target, f"opkg install --force-depends --force-downgrade --force-reinstall {packages_installed}", timeout=120, logger=logger)
        linux.run(f"rm {conf}; if [ -e {backup} ]; then mv {backup} {conf}; fi")
        assert returncode == 0, f"Error: opkg install failed with return code {returncode}"

def update(target: Target, args):
    image_type_mapping = {
        "ipk": update_ipk,
        "mender": update_mender,
        "sdimg": update_sdimg,
    }
    image_extension_mapping = {
        ".wic": update_sdimg,
        ".sdimg": update_sdimg,
        ".img": update_sdimg,
        ".mender": update_mender,
        ".ipk": update_ipk
    }
    update_func = None
    if args.image_type in image_extension_mapping:
        update_func = image_type_mapping[args.image_type]
    else:
        extension = os.path.splitext(args.image)[1]
        if extension in image_extension_mapping:
            update_func = image_extension_mapping[extension]
        elif extension in [".bz2", ".gz", ".xz", ".zstd"]:
            without_ext = os.path.splitext(args.image)[0]
            extension = os.path.splitext(without_ext)[1]
            if extension in image_extension_mapping:
                update_func = image_extension_mapping[extension]
    if update_func is None:
        print(f"Error: Cannot determine image type from filename {args.image}, please specify type with --image-type parameter")
        sys.exit(1)
    if image_is_on_server(args.image):
        pass
    elif not Path(args.image).exists():
        print(f"Error: Image file {args.image} does not exist")
        sys.exit(1)
    if update_func == update_sdimg:
        if args.fitimage is None:
            if image_is_on_server(args.image):
                print("Error: --fitimage parameter must be provided if --image is a URL")
                sys.exit(1)
            image = Path(args.image)
            args.fitimage = str(Path(image.parent, "fitImage-manufacturing"))
            if image_is_on_server(args.image):
                # convert http:/ back to http://
                args.fitimage = args.fitimage.replace(":/", "://")
        if not image_is_on_server(args.fitimage) and not Path(args.fitimage).exists():
            print(f"Error: fitImage file {args.fitimage} does not exist")
            sys.exit(1)
    update_func(target, args)


def get_artifact_name(target, args):
    transition_to_linux(target)
    linux = target.get_driver("ShellDriver")
    stdout, _, _ = linux.run("mender show-artifact")
    return stdout[0]


def write_config(args):
    template_file = str(Path(__file__).parent / "config-templates" / f"{args.usrp_type}.yml")
    config_template = Template(filename=template_file)
    content = config_template.render(
        uartSerial=args.uart_serial,
        serverip=args.server_ip,
    )
    output_path = Path(args.output)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(content)
    print(f"Config written to {args.output}", flush=True)

def main():
    def parse_args():
        """Parse the command line arguments"""
        parser = argparse.ArgumentParser()
        parser.add_argument("-s", "--uart-serial", type=str, help="UART serial number", required=True)
        parser.add_argument(
            "-t", "--usrp-type", type=str, help="USRP model", required=True, choices=usrp_types
        )
        parser.add_argument(
            "-v", "--verbose", action="count", default=0, help="Increase verbosity"
        )
        subparsers = parser.add_subparsers(
            dest="command",
            title="available subcommands",
            metavar="COMMAND",
        )
        subparser = subparsers.add_parser("update")
        subparser.add_argument("-i", "--image-type", type=str, help="The image type to update", choices=["sdimg", "mender", "ipk"], default=None)
        subparser.add_argument("--fitimage", type=str, help="The fitImage file to update", default=None)
        subparser.add_argument("image", type=str, help="The image file to update")

        subparser = subparsers.add_parser("install")
        subparser.add_argument("packages_dir", type=str, help="The parent directory of the directories which contain the packages")
        subparser.add_argument("package", nargs="*", type=str, help="Package which should be removed and installed again")

        subparser = subparsers.add_parser("get_artifact_name")

        subparser = subparsers.add_parser("write_config", help="Render a labgrid environment YAML from the built-in device template")
        subparser.add_argument("-o", "--output", type=str, required=True, help="Output file path for the generated YAML config")
        subparser.add_argument("--server-ip", type=str, default="10.88.137.10", help="Server IP address rendered into the template (default: 10.88.137.10)")

        args = parser.parse_args()
        return args

    args = parse_args()
    if args.verbose == 0:
        loglevel = logging.INFO
    else:
        loglevel = logging.DEBUG

    basicConfig(
        level=loglevel,
        stream=sys.stderr
    )
    if args.verbose >= 2:
        StepLogger.start()
    if args.command == "write_config":
        write_config(args)
        return

    template_file = str(Path(__file__).parent / "config-templates" / f"{args.usrp_type}.yml")
    config_template = Template(filename=template_file)
    with tempfile.NamedTemporaryFile() as f:
        config_file = f.name
        content = config_template.render(
            uartSerial=args.uart_serial,
            serverip="10.88.137.10"
        )
        f.write(content.encode())
        f.seek(0)
        target = Environment(config_file).get_target()
        if args.command == "update":
            update(target, args)
        elif args.command == "install":
            update_packages(target, args)
        elif args.command == "get_artifact_name":
            print(get_artifact_name(target, args))
        else:
            raise NotImplementedError()


if __name__ == "__main__":
    main()
