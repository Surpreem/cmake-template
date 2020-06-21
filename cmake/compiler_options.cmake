# https://stackoverflow.com/a/46000520

# log all *_INIT variables
get_cmake_property(_varNames VARIABLES)
list (REMOVE_DUPLICATES _varNames)
list (SORT _varNames)
foreach (_varName ${_varNames})
    if (_varName MATCHES "_INIT$")
        message(STATUS "${_varName}=${${_varName}}")
    endif()
endforeach()

# change compiler's default options
if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    # to override compiler's warning option
    string (REGEX REPLACE "/W[0-4]" "" CMAKE_CXX_FLAGS_INIT "${CMAKE_CXX_FLAGS_INIT}")
endif()
