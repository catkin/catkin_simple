from __future__ import print_function

from catkin_pkg.package import _get_node_value

from xml.dom.minidom import parseString


def get_catkin_depends(data):
    catkin_depends = []
    dom = parseString(data)
    root = [x for x in dom.childNodes if x.nodeType == x.ELEMENT_NODE and x.tagName == 'package'][0]
    for elem in root.childNodes:
        if elem.nodeType == elem.ELEMENT_NODE and elem.tagName in ['catkin_depend']:
            catkin_depends.append(_get_node_value(elem))

    return catkin_depends


def run_preprocessor(data):
    dom = parseString(data)
    root = [x for x in dom.childNodes if x.nodeType == x.ELEMENT_NODE and x.tagName == 'package'][0]
    root.removeAttribute('preprocessor')
    found_buildtool_catkin = False
    for elem in root.childNodes:
        if elem.nodeType == elem.ELEMENT_NODE and elem.tagName in ['catkin_depend', 'depend']:
            elem.tagName = 'run_depend'
            new_elem = dom.importNode(elem, True)  # deep copy
            new_elem.tagName = 'build_depend'
            root.appendChild(new_elem)
        if elem.nodeType == elem.ELEMENT_NODE and elem.tagName == 'buildtool_depend':
            value = _get_node_value(elem)
            if value == 'catkin':
                found_buildtool_catkin = True
    if not found_buildtool_catkin:
        # Add a buildtool_depend on catkin
        ele = dom.createElement('buildtool_depend')
        ele.appendChild(dom.createTextNode('catkin'))
        root.appendChild(ele)
    return dom.toxml()


if __name__ == '__main__':
    fname = '/Users/william/devel/catkin_simple/test_ws/src/foo/package.xml'
    with open(fname, 'r') as f:
        print(run_preprocessor(f.read(), fname))
