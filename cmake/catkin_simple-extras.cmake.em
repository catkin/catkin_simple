# Generated from: catkin_simple/cmake/catkin_simple-extras.cmake.em

if(_CATKIN_SIMPLE_EXTRAS_INCLUDED_)
  return()
endif()
set(_CATKIN_SIMPLE_EXTRAS_INCLUDED_ TRUE)

include(CMakeParseArguments)

@[if DEVELSPACE]@
# cmake dir in develspace
set(catkin_simple_CMAKE_DIR "@(CMAKE_CURRENT_SOURCE_DIR)/cmake")
@[else]@
# cmake dir in installspace
set(catkin_simple_CMAKE_DIR "@(PKG_CMAKE_DIR)")
@[end if]@

macro(catkin_simple)
  set(${PROJECT_NAME}_TARGETS )
  set(${PROJECT_NAME}_LIBRARIES )

  find_package(catkin REQUIRED)

  message("${PROJECT_NAME}_BUILD_DEPENDS: ${${PROJECT_NAME}_BUILD_DEPENDS}")

  # Parse the raw package.xml for catkin_depends
  execute_process(COMMAND ${PYTHON_EXECUTABLE}
    ${catkin_simple_CMAKE_DIR}/parse_package_xml.py
    ${CMAKE_CURRENT_SOURCE_DIR}/package.xml
    OUTPUT_VARIABLE ${PROJECT_NAME}_CATKIN_DEPENDS
  )
  find_package(catkin REQUIRED COMPONENTS ${${PROJECT_NAME}_CATKIN_DEPENDS})
  include_directories(include ${catkin_INCLUDE_DIRS})

endmacro()

macro(cs_add_executable)
  list(APPEND ${PROJECT_NAME}_TARGETS ${ARGV0})
  add_executable(${ARGN})
  target_link_libraries(${ARGV0} ${catkin_LIBRARIES})

endmacro()

macro(cs_add_library)
  list(APPEND ${PROJECT_NAME}_TARGETS ${ARGV0})
  list(APPEND ${PROJECT_NAME}_LIBRARIES ${ARGV0})
  add_library(${ARGN})
  target_link_libraries(${ARGV0} ${catkin_LIBRARIES})

endmacro()

macro(cs_export)
  # TODO: allow extension of parameters to catkin_package
  catkin_package(
    INCLUDE_DIRS include
    LIBRARIES ${${PROJECT_NAME}_LIBRARIES}
    CATKIN_DEPENDS ${${PROJECT_NAME}_CATKIN_DEPENDS}
  )

endmacro()
