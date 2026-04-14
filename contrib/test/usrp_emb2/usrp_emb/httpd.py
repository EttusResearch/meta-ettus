import http.server
import time
import os
import pyroute2
import socketserver
import threading
from functools import partial
from pathlib import Path

class ThreadingHTTPServer(socketserver.ThreadingMixIn, http.server.HTTPServer):
    pass

class HTTPServer:
    def __init__(self, path, remote_ip, port_range=range(8313, 8313+100)):
        self.path = path
        self.port_range = port_range
        self.port = None
        self.old_path = None
        self.httpd = None
        self.server_started = threading.Event()

        with pyroute2.IPRoute() as ipr:
            r = ipr.route('get', dst=remote_ip)
            for attr in r[0]['attrs']:
                if attr[0] == 'RTA_PREFSRC':
                    self.ip = attr[1]

    def get_url(self, filename):
        path = Path(self.path) / filename
        assert path.exists()
        return f"http://{self.ip}:{self.port}/{filename}"

    def __enter__(self):
        def start_server():
            for port in self.port_range:
                try:
                    Handler = http.server.SimpleHTTPRequestHandler
                    self.httpd = ThreadingHTTPServer(("", port), Handler)
                    self.port = port
                    self.server_started.set() # signal that the server is running
                    self.httpd.serve_forever()
                    break
                except OSError as e:
                    pass
            self.server_started.set() # signal that we have given up

        # Kind of annoying, but to work with older pythons where
        # SimpleHTTPRequestHandler doesn't take a directory parameter but only
        # serves the current directory:
        self.old_path = os.getcwd()
        os.chdir(self.path)

        self.thread = threading.Thread(target=start_server)
        self.thread.start()
        self.server_started.wait()
        if self.port is None:
            raise RuntimeError("Failed to start HTTP server (port range: {}-{})".format(
                self.port_range.start, self.port_range.stop-1))
        return self

    def __exit__(self, type, value, exc):
        if self.httpd is not None:
            self.httpd.shutdown()
            self.httpd.server_close()
        if self.old_path is not None:
            os.chdir(self.old_path)

if __name__ == '__main__':
    with HTTPServer("/tmp", "127.0.0.1") as server:
        print("server ip", server.ip)
        print("server port", server.port)
        time.sleep(300)

