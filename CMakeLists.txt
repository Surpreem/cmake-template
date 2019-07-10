cmake_minimum_required(VERSION 3.12)

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
option(ENABLE_CATCH "Enable Catch 2 and Trompeloeil")
option(ENABLE_GOOGLE_TEST "Enable Google Test and Mock")
option(ENABLE_SPDLOG "Enable spdlog")
option(ENABLE_YAML_CPP "Enable Yaml-cpp")

#
# Asio C++
if(ENABLE_ASIO_CPP)
    download_project(
        PROJ asio
        GIT_REPOSITORY https://github.com/chriskohlhoff/asio.git
        GIT_TAG asio-1-13-0
        ${UPDATE_DISCONNECTED_IF_AVAILABLE}
    )

    # Use when using ASIO 1.12.2 or below
    #add_definitions(-DASIO_STANDALONE)

    include_directories(${asio_SOURCE_DIR}/asio/include)
endif()

#
# Boost C++ Libraries
if(ENABLE_BOOST)
    set(ENV{BOOST_ROOT} ${BOOST_HOME})

    find_package(Boost)
    include_directories(${Boost_INCLUDE_DIRS})
    link_directories(${Boost_LIBRARY_DIRS})

    if(BOOST_DYN_LINK)
        add_definitions(-DBOOST_ALL_DYN_LINK)
    endif()
endif()

#
# Catch 2
if(ENABLE_CATCH)
    download_project(
        PROJ catch
        GIT_REPOSITORY https://github.com/catchorg/Catch2.git
        GIT_TAG v2.7.2
        ${UPDATE_DISCONNECTED_IF_AVAILABLE}
    )

    add_subdirectory(${catch_SOURCE_DIR} ${catch_BINARY_DIR} EXCLUDE_FROM_ALL)
    #include_directories(${catch_SOURCE_DIR}/single_include)

    #
    # Trompeloeil
    download_project(
        PROJ trompeloeil
        GIT_REPOSITORY https://github.com/rollbear/trompeloeil.git
        GIT_TAG v34
        ${UPDATE_DISCONNECTED_IF_AVAILABLE}
    )

    include_directories(${trompeloeil_SOURCE_DIR}/include)
endif()

#
# google test
if(ENABLE_GOOGLE_TEST)
    download_project(
        PROJ googletest
        GIT_REPOSITORY https://github.com/google/googletest.git
        GIT_TAG release-1.8.1
        ${UPDATE_DISCONNECTED_IF_AVAILABLE}
    )

    # Prevent GoogleTest from overriding our compiler/linker options
    # when building with Visual Studio
    set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

    add_subdirectory(${googletest_SOURCE_DIR} ${googletest_BINARY_DIR} EXCLUDE_FROM_ALL)

    # When using CMake 2.8.11 or later, header path dependencies
    # are automatically added to the gtest and gmock targets.
    # For earlier CMake versions, we have to explicitly add the
    # required directories to the header search path ourselves.
    if (CMAKE_VERSION VERSION_LESS 2.8.11)
        include_directories("${gtest_SOURCE_DIR}/include"
                            "${gmock_SOURCE_DIR}/include")
    endif()
endif()

#
# spdlog
if(ENABLE_SPDLOG)
    download_project(
        PROJ spdlog
        GIT_REPOSITORY https://github.com/gabime/spdlog.git
        GIT_TAG v1.3.1
        ${UPDATE_DISCONNECTED_IF_AVAILABLE}
    )

    add_definitions(-DSPDLOG_COMPILED_LIB)

    add_subdirectory(${spdlog_SOURCE_DIR} ${spdlog_BINARY_DIR} EXCLUDE_FROM_ALL)
endif()

#
# yaml-cpp
if(ENABLE_YAML_CPP)
    download_project(
        PROJ yamlcpp
        GIT_REPOSITORY https://github.com/jbeder/yaml-cpp.git
        GIT_TAG master
        ${UPDATE_DISCONNECTED_IF_AVAILABLE}
    )

    set(YAML_CPP_BUILD_TESTS OFF CACHE BOOL "" FORCE)

    add_subdirectory(${yamlcpp_SOURCE_DIR} ${yamlcpp_BINARY_DIR} EXCLUDE_FROM_ALL)
    #include_directories(${yamlcpp_SOURCE_DIR}/include)
endif()

#
# External projects end


# C++ standard version
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Compiler options
message(STATUS "** Setting Compiler options")
if(MSVC)
    # https://docs.microsoft.com/ko-kr/cpp/porting/modifying-winver-and-win32-winnt
    add_definitions(-D_WIN32_WINNT=0x0601)
    add_definitions(-D_UNICODE)
    add_definitions(-DUNICODE)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W4 /WX")

    # for Visual Studio (use when the warning occurs)
    # boost: https://github.com/boostorg/beast/issues/1272
    # yaml-cpp
    #add_definitions(-D_SILENCE_CXX17_ALLOCATOR_VOID_DEPRECATION_WARNING)

    # for using windows environment variables
    # https://cmake.org/cmake/help/latest/policy/CMP0074.html
    cmake_policy(SET CMP0074 NEW)
else()
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Wno-long-long -pedantic -Werror")
endif()

# For Visual Studio solution
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

#add_subdirectory(src)
add_subdirectory(test)
