#!/usr/bin/env python3

import contextlib
import psutil
import random
import subprocess
import tempfile


class Xsdb:
    def __init__(self, port):
        self.port = port

    def run_script(self, text):
        script = f"connect -host localhost -port {self.port}\n"
        script += text

        with tempfile.NamedTemporaryFile() as f:
            f.write(script.encode('ascii'))
            f.flush()
            subprocess.run(['xsdb', f.name])


class XilinxJtag:
    def __init__(self, manufacturer, product, serial):
        self.filter = f"{manufacturer}/{product}/{serial}"

    def _start_hw_server(self):
        """
        Start a hw_server instance for this cable on a random port, and return
        a tuple of (process, port)
        """
        while True:
            # default port is 3121, skip that one
            port = random.randint(3122, 3222)

            args = ["hw_server", "-p0", "-s", f"tcp::{port}",
                    "-e", f"set jtag-port-filter {self.filter}"]
            p = subprocess.Popen(args)
            if p.poll() is None:
                return (p, port)

    @contextlib.contextmanager
    def xsdb(self):
        (proc, port) = self._start_hw_server()
        try:
            yield Xsdb(port)
        finally:
            for child in psutil.Process(proc.pid).children(recursive=True):
                child.kill()
            proc.terminate()


if __name__ == '__main__':
    x = XilinxJtag("Digilent", "JTAG-ONB6", "2516351FE64E")
    with x.xsdb() as xsdb:

        script = """
        targets
        targets -set -filter {name =~ "Cortex-A53 #0"}
        """
        xsdb.run_script(script)
