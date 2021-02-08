#!/usr/bin/env python3

import json
import sys
from junit_xml import TestSuite, TestCase


def bist_json_to_xml(j, output):
    cases = []
    for k, v in j.items():
        case = TestCase(f'bist_{k}', stdout=v)
        success = 'status' in v and v['status']
        if not success:
            msg = "bist failed"
            if 'error_msg' in v:
                msg = v['error_msg']
            case.add_failure_info(msg)
        cases.append(case)
    ts = TestSuite('bist', cases)
    with open(output, 'w') as f:
        f.write(TestSuite.to_xml_string([ts]))


def main():
    with open(sys.argv[1], 'r') as f:
        j = json.load(f)
    bist_json_to_xml(j, sys.argv[2])


if __name__ == '__main__':
    main()
