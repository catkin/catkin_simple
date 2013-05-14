cmake_minimum_required(VERSION 2.8.3)
project(catkin_simple)

find_package(catkin REQUIRED)

catkin_python_setup()

catkin_package(CFG_EXTRAS catkin_simple-extras.cmake)
