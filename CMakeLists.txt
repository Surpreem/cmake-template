cmake_minimum_required(VERSION 3.12)

# display current compiler options
# - place this statement before project()
# - delete CMake cache and regenerate it
# - check your IDE's output display window
#
# to change compiler's default options
# - change compiler options in compiler_options.cmake
# - delete CMake cache and recreate it
set(CMAKE_USER_MAKE_RULES_OVERRIDE "${CMAKE_CURRENT_LIST_DIR}/cmake/compiler_options.cmake")

project(cmake_template)

# Project basic path
set(PROJECT_ROOT ${CMAKE_CURRENT_SOURCE_DIR})
set(INCLUDE_PATH ${PROJECT_ROOT}/include)
set(SOURCE_PATH ${PROJECT_ROOT}/src)
set(TEST_PATH ${PROJECT_ROOT}/test)
if (NOT EXTERNAL_PATH)
    set(EXTERNAL_PATH ${PROJECT_ROOT}/external)
endif()

set(LIB_PATH ${PROJECT_ROOT}/lib)
set(BIN_PATH ${PROJECT_ROOT}/bin)
set(TEST_BIN_PATH ${BIN_PATH}/test)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${LIB_PATH})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${LIB_PATH})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${BIN_PATH})

# ${SOURCE_PATH}: for including headers in src directory
# ${PROJECT_ROOT}: for including headers in test directory. The path starts from test directory.
#  - ex. test/.../...
include_directories(${INCLUDE_PATH} ${EXTERNAL_PATH} ${SOURCE_PATH} ${PROJECT_ROOT})
link_directories(${LIB_PATH})


# for DownloadProject
if (CMAKE_VERSION VERSION_LESS 3.2)
    set(UPDATE_DISCONNECTED_IF_AVAILABLE "")
else()
    set(UPDATE_DISCONNECTED_IF_AVAILABLE "UPDATE_DISCONNECTED 1")
endif()

# Include
include(CTest)
include(cmake/DownloadProject.cmake)


# External projects
option(ENABLE_ASIO_CPP "Enable ASIO C++")
option(ENABLE_BOOST "Enable Boost C++ Libraries")
option(ENABLE_CATCH "Enable Catch2 and Trompeloeil")
option(ENABLE_FLATBUFFERS "Enable Flatbuffers")
option(ENABLE_GOOGLE_TEST "Enable Google Test and Mock")
option(ENABLE_SPDLOG "Enable spdlog")
option(ENABLE_YAML_CPP "Enable Yaml-cpp")
option(ENABLE_ZMQ "Enable ZeroMQ")

include(cmake/external_projects.cmake)


# C++ standard version
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Compiler options
message(STATUS "** Setting Compiler options")
if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    # https://docs.microsoft.com/ko-kr/cpp/porting/modifying-winver-and-win32-winnt
    add_compile_definitions(_WIN32_WINNT=0x0601)
    add_compile_definitions(_UNICODE)
    add_compile_definitions(UNICODE)
    add_compile_options(/W4 /WX)

    # for Visual Studio (use when the warning occurs)
    # boost: https://github.com/boostorg/beast/issues/1272

    if(ENABLE_CATCH)
        # Trompeloeil
        # warning STL4015
        # - The std::iterator class template (used as a base class to provide typedefs) is deprecated in C++17.
        add_compile_definitions(_SILENCE_CXX17_ITERATOR_BASE_CLASS_DEPRECATION_WARNING)
    endif()

    if(ENABLE_YAML_CPP)
        # warning STL4009
        # - std::allocator<void> is deprecated in C++17.
        #add_compile_definitions(_SILENCE_CXX17_ALLOCATOR_VOID_DEPRECATION_WARNING)
    endif()

    # for using windows environment variables
    # https://cmake.org/cmake/help/latest/policy/CMP0074.html
    cmake_policy(SET CMP0074 NEW)

    # For Visual Studio solution
    set_property(GLOBAL PROPERTY USE_FOLDERS ON)
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    if(WIN32)
        # to fix 'too many sections' and 'File too big' compile error of obj files
        add_compile_options(-Wa,-mbig-obj)
    endif()

    add_compile_options(-Wall -Wextra -Wno-long-long -Wconversion -pedantic -Werror)
endif()

add_subdirectory(src)
add_subdirectory(test)
