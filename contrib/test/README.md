# Scrips for automatic test execution

## Theory of operation

This folder contains various scripts for automatic test execution (see next section for details to each script).

The overall architecture is the following:

1. The filesystem image is copied from a server
2. The rootfs partition is extracted (an .ext4 file is generated)
3. The rootfs-partition is loop-mounted
4. The rootfs partition is provided to the device under test by sharing its contents
    - using TFTP for loading the microcontroller firmware and the kernel in the U-Boot bootloader
    - using NFS to serve as the root filesystem (`/`) when booting into Linux

## Setup Guides

### Server

See [Server Setup Guide.md](Server Setup Guide) for information about the setup for loop-mounting the rootfs image and serving it using TFTP and NFS.

### USRP device under test

No special setup is required other than providing a standard filesystem image on an SD card. The image must contain a U-Boot bootloader which is capable of booting from network.

Note: network booting feature was added to U-Boot bootloader in the filesystem images which are based on the thud branch or later (=UHD 3.15 and newer).

### Hardware configuration

The host PC and the USRP device under test must be connected as follows:

- Network connection from host PC to USRP device
    - This can be either a direct network connection or a connection via a router/switch
    - The network should contain a DHCP server for the USRP device to obtain a dynamic IP address
    - Alternatively, you have to set an `ipaddress` and change the `netboot` command in U-Boot and set a static IP address in `/data/network/eth0.conf`
    - For installing additional dependencies before executing the test, internet access is required. Alternatively the dependency would have to be provided by the local server and installed accordingly.

- USB serial console of the USRP connected to the host PC
    - The exact naming of the USB device nodes in `/dev/serial/by-id` must be confiured accordingly in the `config.conf`. This file is needed by some scripts, see below.

## Contents

This folder contains scripts for automatic test execution.

**Scripts for downloading and loop-mounting the filesystem image**

- **copy-image.sh**:
    - copies the image from a local or remote location (e.g. HTTP or FTP server)
    - calls extract_ext4.sh to extract the rootfs partition if the image is not a .ext4 file already
    - re-sets the mountpoint-symlink to the extracted .ext4 files.
    - Note:  the script evaluates the `/etc/fstab` file to resolve the symlink location from the mount point.
    - usage: `copy-image.sh <origin> <imagesdir> <mountpoint>`, where
        - `<origin>` is the location of the filesystem image (either locally or on a server).
        - `<imagesdir>` is the folder where the image should be copied to
        - `<mountpoint>` is the mountpoint to which the rootfs partition (.ext4 file) is loop-mounted. The mount-point is assumed to be a symlink (e.g. `e320.ext4 -> developer-image-ni-neon-rev2-mender--YYYYMMDDHHMMSS.ext4`).

- **extract_ext4.sh**:
    - This file extracts the rootfs partition file from an SD card image file and generates an .ext4 image file with the same base name
      (e.g. `developer-image-ni-neon-rev2-mender.sdimg.bz2` extracts to `developer-image-ni-neon-rev2-mender.ext4`)
    - supported formats: uncompressed (.sdimg, .wic), gzip compressed (.sdimg.gz, .wic.gz) and bzip2 compressed (.sdimg.bz2, .wic.bz2)
    - usage: `extract_ext4.sh <image>`, where
        - `<image>` is the filesystem image file

**Scripts for interacting with the device (boot, run tests, shutdown)**

The following scripts require a config.conf file to be present in the same directory as the scripts.
Alternatively, you can also specify an additional parameter `-c <configfile>` to provide a config file which is in a different location than the scripts.

Use the `config.conf.sample` file as template and change the settings accordingly (especially the parameters `zynq_uart`, `stm_uart`, `nfsroot` and `tftproot`).
The configuration for each device must be under a section, e.g. `[e320]`. This name is what you need to pass as `-t` parameter to the following scripts (e.g. `-t e320`)

- **mount_nfs** (Python script)
    - This script loop-mounts the rootfs image (.ext4 file)
    - The NFS server should be configured (see Setup Guide) to serve the mounted directory with the USRP device under test
     - As part of the mount, the `/etc/resolv.conf` symlink to the systemd-generated `resolv.conf` file is removed and instead, a symlink is set to `/proc/net/pnp`. This file contains the DNS configuration obtained by the kernel while acquiring a DHCP address. This is needed because the systemd name resolution does not work when mounted the root filesystem is mounted via NFS.
     - usage: `mount_nfs [-c <configfile>] -t <device>`

- **run_boot** (Python script)
    - This script boots the USRP device via network boot:
    - ... Set the required parameters for network boot
    - ... Run network boot
    - ... wait for the login prompt; login
    - ... print network settings to get the IP address of the device
    - The boot logfile is written to the file configured as `boot_logfile` in the config.conf file
    - usage: `run_boot [-c <configfile>] -t <device>`

- **run_test** (Python script)
    - This script executes the tests on the device:
    - ... Extract the IP address from the boot logfile (configuration `boot_logfile`)
    - ... Copies resources (scripts) needed for the test to the device (using `scp`)
    - ... Install additional packages (currently python3 package `unittest-xml-reporting`)
    - ... Execute the test
    - ... Copy back the test logfiles to the host PC (using `scp`)
    - usage: `run_test [-c <configfile>] -t <device>`

- **run_poweroff** (Python script)
    - This script powers off the device:
    - ... execute the command `poweroff` on the serial console)
    - ... wait for the shutdown process to finish
    - ... check that there are no further kernel messages printed after (`reboot: Power down` which would indicate a stack trace)
    - The poweroff logfile is written to the file configured as `poweroff_logfile` in the config.conf file
    - usage: `run_poweroff [-c <configfile>] -t <device>`

- **umount_nfs** (Python script)
    - This script unmounts the rootfs image
    - The `nfs-kernel-server` service is restarted before doing the unmount because otherwise a `umount: device is busy` error is returned when trying to unmount
     - usage: `umount_nfs [-c <configfile>] -t <device>`

- **run_all** (Shell script)
    - This script just calls the above scripts after each other (`mount_nfs`, `run_boot`, `run_test`, `run_poweroff`, `umount_nfs`)
    - usage `run_all <device>`

**Test scripts**

Currently there is only one test script:

- **usrp_test.py**
    - This script utilizes the Python `unittest` framework to execute tests (reference: https://docs.python.org/3/library/unittest.html)
    - It uses `xml-unittest-reporting` (aka `xmlrunner`) to generate a XML report of the tests

`usrp_test.py` can also be executed manually:

    # test run with verbose output
    ./usrp_test.py -vv

    # test run with verbose output and XML report
    python3 -m xmlrunner usrp_test.py -vv

The following tests are executed by `usrp_test.py`:

- **test_boot_kernel**
    - Check kernel boot log
    - The kernel logs of the verious loglevels are also written to log files: `dmesg-kernel-<num>-<loglevel>.txt`
    - Pass criteria: no errors in the kernel log

- **test_boot_userspace**
    - Check the userspace log (systemd and derived services/processes)
    - The kernel logs of the verious loglevels are also written to log files: `dmesg-userspace-<num>-<loglevel>.txt`
    - Pass criteria: no errors and no warnings in the usersoace log

- **test_systemd_system_running**
    - Check that systemd successfully started all services (e.g. `usrp-hwd`)
    - The test has a timeout of 30 seconds
    - Pass criteria: All services were started successfully

- **test_systemd_usrp_hwd_status**
    - Pass criteria: `usrp-hwd` service (MPM) is running and log contains no warnings or errors

- **test_uhd_usrp_probe**
    - Pass criteria: `uhd_usrp_probe` (on own device) executed successfully (return code 0, no erors in log, output on stdout available)

- **test_network_up**
    - Pass criteria: `eth0` network is up and configured as expected.

- **test_network_resolve**
    - Pass criteria: DNS server is configured and domain or search space is configured

- **test_mpm_init_status**
    - Use MPM shell on localhost to check MPM initialization status
    - Pass criteria: Connection was successfuly, methods were registered in MPM shell, MPM init status is okay

- **test_sshd**
    - Test if ssh daemon works by ssh'ing to root@localhost
    - Pass criteria: `ssh` command was successfully executed

- **test_hostname**
    - Pass criteria: the hostname matches the valid USRP default hostnames (`ni-<devitype>-<serialnr>`, e.g. `ni-e320-0123456`)

- **test_lsb_release**
    - Pass criteria: `lsb_release -a` executes successfully (return code 0, etc.)
    - Output is written to log files

- **test_uhd_config_info**
    - Pass criteria: `uhd_config_info --print-all` executes successfully (return code 0, etc.)
    - Output is written to log files

- **test_usb_detected**
    - Pass criteria: `lsusb` executes successfully and returns correct number of USB devices. Also check `dmesg` output to confirm that the USB storage device is detected.
    - Output is written to log files
