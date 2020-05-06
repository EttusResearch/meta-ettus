SUMMARY = "Builds the package manager config files"
LICENSE = "MIT"

INHIBIT_DEFAULT_DEPS = "1"
PACKAGES = ""

inherit nopackages

deltask do_fetch
deltask do_unpack
deltask do_patch
deltask do_configure
deltask do_compile
deltask do_install
deltask do_populate_sysroot

do_package_index[nostamp] = "1"
do_package_index[depends] += "${PACKAGEINDEXDEPS}"

python do_package_feed() {
    def _get_feed_base_paths_from_deploy_dir_base():
        deploy_dir_base = d.getVar('DEPLOY_DIR_BASE')

        if deploy_dir_base and os.path.isdir(deploy_dir_base):
            return os.path.relpath(d.getVar('DEPLOY_DIR_IPK'), deploy_dir_base)
        else:
            return ''

    def _get_archs_from_deploy_dir_ipk():
         deploy_dir_ipk = d.getVar("DEPLOY_DIR_IPK")

         if deploy_dir_ipk and os.path.isdir(deploy_dir_ipk):
             feed_archs_list = [f for f in os.listdir(deploy_dir_ipk) if os.path.isdir(os.path.join(deploy_dir_ipk, f))]
             return ' '.join(feed_archs_list)
         else:
             return ''

    import os
    from oe.package_manager import OpkgPM

    if d.getVar('IMAGE_PKGTYPE') != 'ipk':
        bb.fatal('This task only supports ipk package format, please set IMAGE_PKGTYPE = "ipk"')

    rootfs = os.path.join(d.getVar("WORKDIR"), 'oe-rootfs-repo')
    opkg_conf = d.getVar("IPKGCONF_TARGET")
    pkg_archs = d.getVar("ALL_MULTILIB_PACKAGE_ARCHS")

    bb.note('Calling OpkgPM(d, rootfs={}, opkg_conf={}, pkg_archs={})'.format(rootfs, opkg_conf, pkg_archs))
    pm = OpkgPM(d, rootfs, opkg_conf, pkg_archs)

    opkg_dir = rootfs + '/etc/opkg'
    bb.utils.mkdirhier(opkg_dir)

    feed_uris = d.getVar('PACKAGE_FEED_URIS') or ""
    feed_base_paths = d.getVar('PACKAGE_FEED_BASE_PATHS') or _get_feed_base_paths_from_deploy_dir_base()
    feed_archs = d.getVar('PACKAGE_FEED_ARCHS') or _get_archs_from_deploy_dir_ipk()

    bb.note('Calling insert_feeds_uris(feed_uris={}, feed_base_paths={}, feed_archs={}'.format(feed_uris, feed_base_paths, feed_archs))
    pm.insert_feeds_uris(feed_uris, feed_base_paths, feed_archs)

    feeds_file = 'base-feeds.conf'
    bb.utils.copyfile(os.path.join(opkg_dir, feeds_file), os.path.join(d.getVar('DEPLOY_DIR_IPK'), feeds_file))
}

addtask do_package_feed before do_build
EXCLUDE_FROM_WORLD = "1"
