
IMAGE_INSTALL += "\
    ${CORE_IMAGE_BASE_INSTALL} \
    boost \
    cmake \
    devmem2 \
    ethtool \
    fftwf-wisdom \
    git \
    glib-2.0 \
    gps-utils-cgps \
    gps-utils-gps2udp \
    gps-utils-gpsmon \
    gsl \
    htop \
    i2c-tools \
    iperf3 \
    libgpiod \
    libudev \
    mpmd \
    nfs-utils-mount \
    openocd \
    openssh-sftp \
    openssh-sftp-server \
    orc \
    overlay-script \
    python3-pip \
    python3-uhd \
    rsync \
    salt-minion \
    screen \
    sshfs-fuse \
    swig \
    tpm-tools \
    trousers \
    tzdata \
    uhd \
    uhd-examples \
    util-linux \
    vim \
    vim-vimrc \
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
