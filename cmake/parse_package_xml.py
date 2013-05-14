#!/usr/bin/env python

from __future__ import print_function

import os
import sys

try:
    from catkin_simple import get_catkin_depends
except ImportError:
    backup_path = sys.path
    try:
        sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))
        from catkin_simple import get_catkin_depends
    except ImportError as e:
        sys.exit("Failed to load catkin_simple: " + str(e))
    finally:
        sys.path = backup_path


def main():
    if len(sys.argv) != 2:
        sys.exit("Usage: parse_package_xml.py <path/to/package.xml>")
    package_xml_path = sys.argv[1]
    if not os.path.exists(package_xml_path):
        sys.exit("Given package.xml does not exist: '{0}'"
                 .format(package_xml_path))
    with open(package_xml_path, 'r') as f:
        catkin_depends = get_catkin_depends(f.read())
    print(";".join(catkin_depends), end='')

if __name__ == '__main__':
    main()
