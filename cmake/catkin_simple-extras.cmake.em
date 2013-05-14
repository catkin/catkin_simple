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
  # call catkin_package_xml() if it has not been called before
  if(NOT _CATKIN_CURRENT_PACKAGE)
    catkin_package_xml()
  endif()

  set(${PROJECT_NAME}_CATKIN_DEPENDS )
  foreach(dep ${${PROJECT_NAME}_BUILD_DEPENDS})
    find_package(${dep} QUIET)
    if(${dep}_FOUND_CATKIN_PROJECT)
      list(APPEND ${PROJECT_NAME}_CATKIN_DEPENDS ${dep})
    endif()
  endforeach()

  # Let find_package(catkin ...) do the heavy lifting
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
  cmake_parse_arguments(CS_PROJECT
    "" "" "INCLUDE_DIRS;LIBRARIES;CATKIN_DEPENDS;DEPENDS;CFG_EXTRAS"
    ${ARGN})
  catkin_package(
    INCLUDE_DIRS include ${CS_PROJECT_INCLUDE_DIRS}
    LIBRARIES ${${PROJECT_NAME}_LIBRARIES} ${CS_PROJECT_LIBRARIES}
    CATKIN_DEPENDS ${${PROJECT_NAME}_CATKIN_DEPENDS} ${CS_PROJECT_CATKIN_DEPENDS}
    DEPENDS ${CS_PROJECT_CATKIN_DEPENDS}
    CFG_EXTRAS ${CS_PROJECT_CFG_EXTRAS}
  )

endmacro()
