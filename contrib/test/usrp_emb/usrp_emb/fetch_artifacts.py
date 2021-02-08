#!/usr/bin/env python3

import argparse
import re
import sys
import tempfile
import urllib.request
import urllib.parse
import yaml
import zipfile
from pathlib import Path


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--filesystem-image', required=True)
    parser.add_argument('--output-dir')
    args = parser.parse_args()

    if Path(args.filesystem_image).exists():
        filesystem_image_url = Path(args.filesystem_image).read_text().strip()
    else:
        filesystem_image_url = args.filesystem_image

    images_url = '/'.join(filesystem_image_url.split('/')[:-1])
    base_url = '/'.join(images_url.split('/')[:-1])
    machine_name = images_url.split('/')[-1]
    rev = re.match(r'.*(rev\d+)', machine_name).group(1)

    output_dir = args.output_dir
    if output_dir is None:
        output_dir = tempfile.mkdtemp()
    output_dir = Path(output_dir)

    manifest = {
        "machine_name": machine_name,
        'images_url': images_url,
        'filesystem_image_url': filesystem_image_url,
    }

    # Retrieve and save the SCU firmware:
    url = urllib.parse.urljoin(base_url + '/', f'ni-titanium-ec-{rev}/chromium-ec-ni-titanium-ec-{rev}.bin')
    urllib.request.urlretrieve(url, output_dir / 'ec.bin')

    # Retrieve and save manufacturing fitImage
    fitimage_name = f"fitImage-manufacturing-image-{machine_name}-{machine_name}"
    url = urllib.parse.urljoin(images_url + '/', fitimage_name)
    urllib.request.urlretrieve(url, output_dir / "fitImage-manufacturing")

    # Retrieve and extract all files needed to boot over JTAG
    with tempfile.NamedTemporaryFile() as temp:
        url = urllib.parse.urljoin(images_url + '/', 'u-boot-jtag-files.zip')
        urllib.request.urlretrieve(url, temp.name)
        with zipfile.ZipFile(temp.name) as z:
            z.extractall(output_dir)

    manifest_file = output_dir / "manifest.yml"
    manifest_file.write_text(yaml.dump(manifest))
    print(output_dir.absolute())
    image_url_file = output_dir / "filesystem-image.url"
    image_url_file.write_text(filesystem_image_url)


if __name__ == '__main__':
    sys.exit(main())
