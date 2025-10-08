#!/usr/bin/env python3
"""
Extract and normalize component version from manifest file.

This script searches for component version information in manifest files and
normalizes the version to a 4-field format (major.minor.patch.build).

Usage:
    python3 extract_uhd_version.py --artifact-path <path> [--manifest-pattern <pattern>] [--component <name>]

Output:
    Prints normalized version to stdout (e.g., "4.9.0.0")
    Debug messages are sent to stderr
"""

import re
import glob
import sys
import os
import argparse

def extract_component_version(manifest_path, component_name='uhd'):
    """Extract and normalize component version from manifest file."""
    try:
        with open(manifest_path, 'r') as f:
            content = f.read()
        
        # Find line starting with component_name followed by alphanumeric chars and version
        pattern = rf'^{re.escape(component_name)}\s+[\w-]+\s+([0-9]+\.[0-9]+\.[0-9]+(?:\.[^\s]*)?)'
        match = re.search(pattern, content, re.MULTILINE)
        
        if not match:
            print(f"Error: Could not extract {component_name} version from manifest file", file=sys.stderr)
            sys.exit(1)
        
        raw_version = match.group(1)
        print(f"Raw extracted version: {raw_version}", file=sys.stderr)
        
        # Split version into parts
        parts = raw_version.split('.')
        
        if len(parts) >= 4:
            # Check if 4th part is numeric
            try:
                int(parts[3])
                # 4th part is numeric, keep first 4 parts
                version = '.'.join(parts[:4])
            except ValueError:
                # 4th part is not numeric, use first 3 + .0
                version = '.'.join(parts[:3]) + '.0'
        else:
            # Only 3 or fewer parts, pad with .0
            version = '.'.join(parts[:3]) + '.0'
        
        return version
        
    except FileNotFoundError:
        print(f"Error: Manifest file not found: {manifest_path}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Error processing manifest file: {e}", file=sys.stderr)
        sys.exit(1)

def main():
    parser = argparse.ArgumentParser(
        description='Extract and normalize component version from manifest file.',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s --artifact-path /path/to/artifacts
  %(prog)s --artifact-path /path/to/artifacts --component gnuradio
  %(prog)s --artifact-path /path/to/artifacts --manifest-pattern "custom-*.manifest"
  %(prog)s -p /path/to/artifacts -c uhd -m "system-*.manifest"
        """
    )
    
    parser.add_argument(
        '--artifact-path', '-p',
        required=True,
        help='Path to directory containing manifest files'
    )
    
    parser.add_argument(
        '--manifest-pattern', '-m',
        default='gnuradio-image-*.manifest',
        help='Glob pattern for manifest files (default: %(default)s)'
    )
    
    parser.add_argument(
        '--component', '-c',
        default='uhd',
        help='Component name to search for (default: %(default)s)'
    )
    
    parser.add_argument(
        '--verbose', '-v',
        action='store_true',
        help='Enable verbose output to stderr'
    )
    
    args = parser.parse_args()
    
    # Find manifest file
    manifest_pattern = os.path.join(args.artifact_path, args.manifest_pattern)
    manifest_files = glob.glob(manifest_pattern)
    
    if not manifest_files:
        print(f"Error: No manifest files found matching {manifest_pattern}", file=sys.stderr)
        sys.exit(1)
    
    manifest_file = manifest_files[0]
    
    if args.verbose:
        print(f"manifest file: {manifest_file}", file=sys.stderr)
        print(f"searching for component: {args.component}", file=sys.stderr)
    
    version = extract_component_version(manifest_file, args.component)
    print(version)  # This goes to stdout and gets captured by bash

if __name__ == "__main__":
    main()