import pytest

from usrp_emb.httpd import HTTPServer


def run_http_servers(port_range):
    with HTTPServer("/tmp", "192.168.0.1", port_range=port_range) as http1:
        print(f"http1 running on port {http1.port}")
        with HTTPServer("/tmp", "192.168.0.1", port_range=port_range) as http2:
            print(f"http2 running on port {http2.port}")


def test_valid_portrange():
    run_http_servers(port_range=range(10000, 10010))


def test_invalid_portrange():
    with pytest.raises(RuntimeError):
        run_http_servers(port_range=range(10000, 10001))
