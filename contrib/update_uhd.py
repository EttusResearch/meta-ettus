#!/usr/bin/env python
#
# Copyright 2018 Ettus Research, a National Instruments Company
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
"""
Utility to update hashes for UHD within meta-ettus.
"""

from __future__ import print_function
import os
import re
import subprocess
import tempfile
import argparse
import shutil
from six import iteritems

UHD_REPO = 'https://github.com/EttusResearch/uhd.git'
GIT_BB_FILES = [
    'meta-ettus-core/recipes-support/uhd/uhd_git.bb',
    'meta-ettus-core/recipes-support/uhd/mpmd_git.bb',
]
DEVICE_INFO = {
    'n3xx': {
        'fpga_append': [
            'meta-sulfur/recipes-support/uhd/uhd-fpga-images_git.bbappend',
            'meta-sulfur/recipes-kernel/linux-firmware/linux-firmware_git.bbappend',
        ],
    },
    'e320': {
        'fpga_append': [
            'meta-neon/recipes-support/uhd/uhd-fpga-images_git.bbappend',
            'meta-neon/recipes-kernel/linux-firmware/linux-firmware_git.bbappend',
        ],
    },
}
BASE_URL = "http://files.ettus.com/binaries/cache"

def parse_args():
    """
    Returns the result of parse_args().
    """
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '-u', '--uhd-path',
        help="Path to UHD git repository. If not provided, will clone a fresh "
             "repo and use that."
    )
    this_repo_dir = os.path.normpath(
        os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
    parser.add_argument(
        '-m', '--meta-ettus-path', default=this_repo_dir,
        help="Path to the meta-ettus repository."
    )
    parser.add_argument(
        '-r', '--uhd-repo', default=UHD_REPO,
        help="UHD repo URL for cloning"
    )
    parser.add_argument(
        '-b', '--branch',
        help="UHD branch"
    )
    parser.add_argument(
        'devices', default=list(DEVICE_INFO.keys()), nargs='*',
        help="List all devices for which updates shall be performed. Default: "
             "All devices."
    )
    return parser.parse_args()


def check_meta_ettus_path(mep):
    """
    Check if mep is a valid path of a meta-ettus repository.
    """
    return os.path.isdir(os.path.join(mep, 'meta-ettus-core'))

def update_uhd_sha(mep, uhd_sha1, branch):
    """
    Update current meta-ettus to latest UHD hash

    mep: meta-ettus path
    uhd_sha1: The git SHA1 for the UHD repo
    branch: The name of the branch we're going to track
    """
    for bbfile in GIT_BB_FILES:
        print("### Updating `{}'...".format(bbfile))
        bbfile_content = open(os.path.join(mep, bbfile)).read()
        bbfile_content = re.sub(
            r'SRCREV = "([a-z0-9]+)"',
            'SRCREV = "{}"'.format(uhd_sha1),
            bbfile_content,
        )
        current_branch = \
            re.search(
                r'SRC_URI = [^;]+;branch=(?P<branch>[^ ]+)',
                bbfile_content).group('branch')
        if branch is None:
            print("### FYI: File {} is referring to git branch {}.".format(
                os.path.basename(bbfile), current_branch))
        else:
            print("### Replacing branch name in SRC_URI with {}".format(branch))
            bbfile_content = re.sub(
                r'(SRC_URI = [^;]+;branch=)([^ ]+)',
                r'\1' + branch,
                bbfile_content,
            )
        open(os.path.join(mep, bbfile), 'w').write(bbfile_content)

def load_manifest(upath):
    """
    Return the manifest as a dictionary
    """
    manifest_path = os.path.join(upath, 'images', 'manifest.txt')
    print("### Reading manifest from {}...".format(manifest_path))
    manifest_contents = open(manifest_path).read()
    manifest = {}
    for line in manifest_contents.split('\n'):
        line_unpacked = line.split()
        try:
            # Check that the line isn't empty or a comment
            if not line_unpacked or line.strip().startswith('#'):
                continue
            target, repo_hash, url, sha256_hash = line_unpacked
            manifest[target] = {
                "repo_hash": repo_hash,
                "url": url,
                "sha256_hash": sha256_hash,
            }
        except ValueError:
            print("WARNING: Invalid line in manifest file:\n"
                  "         {}".format(line))
            continue
    return manifest

def get_fpga_target_list(src_uri_content):
    """
    sdf
    """
    url_name_pairs = [
        s.strip(" \\")
        for s in src_uri_content.strip().split("\n")
    ]
    return [
        u
        for u in url_name_pairs
        if not u.startswith('http')
    ], [
        re.search(
            r'http://[a-z0-9.-/-]+/([a-z0-9_]+)[-a-z0-9]*\.zip;name=(.+)',
            u).groups()
        for u in url_name_pairs
        if u.startswith('http')
    ]


def get_new_src_uri_str(src_uri_key, extra_lines, target_dict):
    """
    Create the SRC_URI_append... string
    """
    num_leading_spaces = len(src_uri_key) + len(' = " ')
    return src_uri_key + ' = " ' + ' \\\n{spaces}'.format(spaces=' ' * num_leading_spaces).join(extra_lines + [
        "{base_url}/{url};name={name}".format(
            base_url=BASE_URL,
            url=t_dict['url'],
            name=name,
        ) for name, t_dict in iteritems(target_dict)
    ]) + ' \\\n{spaces}"'.format(spaces=' ' * (num_leading_spaces - 2))


def update_fpga_hashes(bbafile, manifest):
    """
    Update the FPGA hashes in the appropriate bbappend file
    """
    print("### Modifying {}...".format(bbafile))
    bbafile_content = open(bbafile).read()
    src_uri_key, src_uri_content = \
        re.search(r'(SRC_URI_append[a-z-_]*)\s+=\s+"([^"]+)"',
                  bbafile_content).groups()
    extra_lines, fpga_target_list = get_fpga_target_list(src_uri_content)
    print("### Found targets:")
    for target, name in fpga_target_list:
        print("### * {}: {}".format(name, target))
    target_dict = {
        name: {
            'target': target,
            'sha': manifest[target]['sha256_hash'],
            'url': manifest[target]['url'],
        }
        for target, name in fpga_target_list
        if target in manifest
    }
    bbafile_content, n_subs = re.subn(
        r'SRC_URI_append[a-z-_]*\s+=\s+"[^"]+"',
        get_new_src_uri_str(src_uri_key, extra_lines, target_dict),
        bbafile_content,
        count=1
    )
    if n_subs != 1:
        print("ERROR: Couldn't find SRC_URI_append string to replace!")
        exit(1)
    for name, t_dict in iteritems(target_dict):
        regex = r'SRC_URI\[{name}.sha256sum\]\s+=\s+"[a-z0-9]+"'.format(name=name)
        new_hash_str = 'SRC_URI[{name}.sha256sum] = "{hash}"'.format(
            name=name,
            hash=t_dict['sha'],
        )
        bbafile_content, n_subs = \
            re.subn(regex, new_hash_str, bbafile_content, count=1)
        if n_subs != 1:
            print("WARNING: Didn't find sha256sum for target {}! Will append."
                  .format(name))
            bbafile_content += "\n" + new_hash_str
    open(bbafile, 'w').write(bbafile_content)


def main():
    """
    Go, go, go!
    """
    args = parse_args()
    print("### Updating meta-ettus...")
    print("### Using meta-ettus repository at: {}".format(args.meta_ettus_path))
    if not check_meta_ettus_path(args.meta_ettus_path):
        print("ERROR: Invalid meta-ettus repository.")
        return False
    temp_dir = None
    if args.uhd_path is None:
        print("### No UHD path given. Cloning fresh repo...")
        temp_dir = tempfile.mkdtemp()
        args.uhd_path = os.path.join(temp_dir, 'uhd')
        subprocess.check_call(['git', 'clone', args.uhd_repo, args.uhd_path])
    print("### Using UHD repo at: {}".format(args.uhd_path))
    if args.branch is not None:
        print("### Switching UHD branch at request of user (-b was provided)")
        print("##### Note: You will need to switch back if you so desire.")
        subprocess.check_call(
            ['git', 'checkout', args.branch], cwd=args.uhd_path)
    print("### Learning git hash of UHD repository...")
    uhd_git_hash = subprocess.check_output(
        ['git', 'rev-parse', 'HEAD'], cwd=args.uhd_path).decode('utf-8').strip()
    print("### Git hash is: {}".format(uhd_git_hash))
    update_uhd_sha(args.meta_ettus_path, uhd_git_hash, args.branch)
    manifest = load_manifest(args.uhd_path)
    for device in args.devices:
        print("### Updating FPGA images for device `{}'...".format(device))
        for bba_file in DEVICE_INFO[device]['fpga_append']:
            update_fpga_hashes(
                os.path.join(args.meta_ettus_path, bba_file), manifest,)
    if temp_dir is not None:
        shutil.rmtree(temp_dir)
    return True


if __name__ == "__main__":
    exit(not main())
