
CORE_IMAGE_EXTRA_INSTALL = "\
    i2c-tools \
    devmem2 \
    screen \
    vim \
    vim-vimrc \
    git \
    swig \
    boost \
    cmake \
    gsl \
    htop \
    glib-2.0 \
    mpmd \
    orc \
    overlay-script \
    libudev \
    iperf3 \
    openocd \
    openssh-sftp \
    openssh-sftp-server \
    fftwf-wisdom \
    uhd \
    uhd-examples \
    python3-pip \
    ethtool \
    sshfs-fuse \
    tzdata \
    trousers \
    tpm-tools \
    salt-minion \
    gps-utils-cgps \
    gps-utils-gps2udp \
    gps-utils-gpsmon \
    rsync \
    nfs-utils-mount \
    python3-uhd \
    "

# including linux-firmware-ni-{e31x,sulfur,neon} with dev-pkgs feature enabled
# also pulls in linux-firmware-dev which then pulls in linux-firmware. This
# causes hundreds of megabytes of uneeded firmware to get pulled in.

# including nfs-utils-mount together dev-pkgs feature enabled also pulls in
# nfs-utils-dev which pulls in nfs-utils which pulls in nfs-utils-client
# which causes a systemd service (proc-fs-nfsd.mount) to fail...

PACKAGE_EXCLUDE = " \
    linux-firmware-dev \
    nfs-utils-dev \
    "
