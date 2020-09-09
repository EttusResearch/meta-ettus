python set_uhd_version_as_pkgv() {
    import pathlib

    workdir=d.getVar('WORKDIR')
    p=pathlib.Path(workdir, 'temp/log.do_configure')
    if p.exists():
        t=p.read_text()
        for line in t.splitlines():
            needle='-- Building version: '
            if line.startswith(needle):
                pkgv=line[len(needle):]
                d.setVar('PKGV', pkgv)
}

python do_package_prepend() {
    bb.build.exec_func("set_uhd_version_as_pkgv", d)
}
