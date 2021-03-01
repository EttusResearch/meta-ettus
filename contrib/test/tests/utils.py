from pathlib import Path
import subprocess

def dt_compatible(s):
    """
    Returns true if the compatible string for the device contains s
    """
    p = Path('/proc/device-tree/compatible')
    return s in p.read_text()

def package_installed(package):
    output = subprocess.check_output(['opkg', 'list-installed', package])
    return len(output) > 0
