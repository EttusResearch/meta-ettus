#!/usr/bin/python3

import os, errno
import argparse
import json
import sys

def force_symlink(file1, file2):
    try:
        os.symlink(file1, file2)
    except OSError as err:
        if err.errno == errno.EEXIST:
            os.remove(file2)
            os.symlink(file1, file2)

def parse_args():
    parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('-I', '--inventory-location', type=str, default="",
                        help="Set custom location for the inventory file")
    parser.add_argument('-i', '--install-location',
                        default="",
                        help="Set custom install location for images")
    parser.add_argument('-d', '--destination-location',
                        default="",
                        help="Set location where the symlinks are created")
    args = parser.parse_args()

    if args.install_location == '':
        args.install_location = '/usr/local/share/uhd/images'
    if args.destination_location == '':
        args.destination_location = args.install_location
    if args.inventory_location == '':
        args.inventory_location = os.path.join(args.install_location, "inventory.json")

    return args

def main():
    args = parse_args()

    with open(args.inventory_location, 'r') as inventory_file:
        inventory = json.load(inventory_file)
    for target in inventory:
        if 'filename' in inventory[target]:
            source = os.path.relpath(os.path.join(args.install_location, inventory[target]['filename']), args.destination_location)
            target = os.path.join(args.destination_location, target)
            force_symlink(source, target)
        else:
            print("error: inventory entry {} has no filename property".format(target))
            raise ValueError

    return 0

if __name__ == "__main__":
    sys.exit(main())
