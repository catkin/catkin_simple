catkin simple
=============

This ``catkin`` package is designed to make the `CMakeLists.txt` of other ``catkin`` packages simpler.

CMakeLists.txt Example
----------------------

Here is an example of a package ``foo`` which depends on other catkin packages::

    cmake_minimum_required(VERSION 2.8.3)
    project(foo)

    find_package(catkin_simple REQUIRED)

    catkin_simple()

    cs_add_library(my_lib src/my_lib.cpp)

    cs_add_executable(my_exec src/main.cpp)
    target_link_libraries(my_exec my_lib)

    cs_install()

    cs_install_scripts(scripts/my_script.py)

    cs_export()

Lets break this down, line by line.

First is the standard CMake header::

    cmake_minimum_required(VERSION 2.8.3)
    project(foo)

Which defines the minimum CMake version and the name of this project.

Next comes the ``find_package`` of ``catkin_simple``::

    find_package(catkin_simple REQUIRED)

This is just like ``find_package`` for any other ``catkin`` package. This command is required.

Then you invoke ``catkin_simple``::

    catkin_simple()

This macro call gathers your build_depend's from the ``package.xml`` of your package. Then does a ``find_package`` on each of them, with ``QUIET`` and no ``REQUIRES`` options. That way if one of the build_depend's are not ``catkin`` packages then they are simply ignored. Packages which are successfully found and identified to be ``catkin`` packages are added to a list of ``catkin depends``. This list of ``catkin depends`` is passed to ``find_package(catkin REQUIRED COMPONENTS ...)``. This command is required.

Additionally, this macro adds the local ``include`` folder and the catkin include directories to the include path with CMake's ``include_directories(...)`` macro, but the local ``include`` folder is only added if it exists.

Next we create a library::

    cs_add_library(my_lib src/my_lib.cpp)

This call does a few things, first it calls directly through to the normal CMake macro ``add_library``, then it calls ``target_link_libraries(my_lib ${catkin_LIBRARIES})`` to link your new library against any catkin libraries you have build depended on in your package.xml. Finally it does some bookeeping so that your library target can be implicitly used later.

Next we add a new executable::

    cs_add_executable(my_exec src/main.cpp)
    target_link_libraries(my_exec my_lib)

This works just like ``cs_add_library``, but it calls CMake's ``add_executable(...)`` instead.

Notice that here we have to explicitly call ``target_link_libraries`` for linking against our library, this is because there is no way to enforce order of target creation. The executable is still automatically linked against the catkin libraries.

Next we install everything::

    cs_install()

    cs_install_scripts(scripts/my_script.py)

The first macro call creates an installation rule for any libraries and executables you created with ``cs_`` prefixed commands. That call can also take zero to many additional targets you wish to install which were created without the ``cs_`` prefixed commands. This command is optional.

The second macro call creates an installation rule for the given scripts, installing them to ``${prefix}/lib/${pkg_name}/``. This command is optional.

Finally, we export everything::

    cs_export()

This command calls ``catkin_package(...)`` under the hood, extending that call with any libraries created and catkin_depends found automatically with ``catkin_simple``. You can also pass in your own arguments to ``catkin_package(...)`` through this command. This command is required.

Known Limitations
-----------------

There are several known assumptions and incorrect behaviors in ``catkin_simple`` which are a result of the trade-off of correctness for convenience.

- There is no warning when a catkin package is not found during ``find_package``.
- There is over linking, as all libraries of all dependencies are linked against all targets indiscriminately.
- Assumes that the ``include`` folder is meant to be in the include path.
