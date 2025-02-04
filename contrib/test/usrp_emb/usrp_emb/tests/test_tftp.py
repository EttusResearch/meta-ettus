import pytest
import tempfile

from usrp_emb.tftp import TFTPServer


def run_tftp_servers(port_range):
    with tempfile.NamedTemporaryFile() as filename:
        with TFTPServer(filename.name, "192.168.0.1", port_range=port_range) as tftp1:
            print(f"tftp1 running on port {tftp1.port}")
            with TFTPServer(
                filename.name, "192.168.0.1", port_range=port_range
            ) as tftp2:
                print(f"tftp2 running on port {tftp2.port}")


def test_valid_portrange():
    run_tftp_servers(port_range=range(10000, 10010))


def test_invalid_portrange():
    with pytest.raises(RuntimeError):
        run_tftp_servers(port_range=range(10000, 10001))
