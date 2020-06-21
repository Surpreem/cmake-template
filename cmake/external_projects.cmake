#
# Asio C++
if(ENABLE_ASIO_CPP)
    download_project(
        PROJ asio
        GIT_REPOSITORY https://github.com/chriskohlhoff/asio.git
        GIT_TAG asio-1-16-1
        ${UPDATE_DISCONNECTED_IF_AVAILABLE}
    )

    # Use when using ASIO 1.12.2 or below
    #add_compile_definitions(ASIO_STANDALONE)

    include_directories(${asio_SOURCE_DIR}/asio/include)
endif()

#
# Boost C++ Libraries
if(ENABLE_BOOST)
    include_directories(${BOOST_HOME}/include)
    link_directories(${BOOST_HOME}/lib)

    if(BOOST_DYN_LINK)
        add_compile_definitions(BOOST_ALL_DYN_LINK)
    endif()
endif()

#
# Catch2
if(ENABLE_CATCH)
    download_project(
        PROJ catch
        GIT_REPOSITORY https://github.com/catchorg/Catch2.git
        GIT_TAG v2.12.2
        ${UPDATE_DISCONNECTED_IF_AVAILABLE}
    )

    add_subdirectory(${catch_SOURCE_DIR} ${catch_BINARY_DIR} EXCLUDE_FROM_ALL)
    #include_directories(${catch_SOURCE_DIR}/single_include)

    #
    # Trompeloeil
    download_project(
        PROJ trompeloeil
        GIT_REPOSITORY https://github.com/rollbear/trompeloeil.git
        GIT_TAG v37
        ${UPDATE_DISCONNECTED_IF_AVAILABLE}
    )

    include_directories(${trompeloeil_SOURCE_DIR}/include)
endif()

#
# flatbuffers
if(ENABLE_FLATBUFFERS)
    download_project(
        PROJ flatbuffers
        GIT_REPOSITORY https://github.com/google/flatbuffers.git
        GIT_TAG v1.12.0
        ${UPDATE_DISCONNECTED_IF_AVAILABLE}
    )

    add_subdirectory(${flatbuffers_SOURCE_DIR} ${flatbuffers_BINARY_DIR} EXCLUDE_FROM_ALL)
    include(cmake/flatbuffers_schema_to_cpp.cmake)
endif()

#
# google test
if(ENABLE_GOOGLE_TEST)
    download_project(
        PROJ googletest
        GIT_REPOSITORY https://github.com/google/googletest.git
        GIT_TAG release-1.10.0
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
        GIT_TAG v1.6.1
        ${UPDATE_DISCONNECTED_IF_AVAILABLE}
    )

    if(SPDLOG_MAKE_LIB)
        add_compile_definitions(SPDLOG_COMPILED_LIB)
    endif()

    add_subdirectory(${spdlog_SOURCE_DIR} ${spdlog_BINARY_DIR} EXCLUDE_FROM_ALL)
endif()

#
# yaml-cpp
if(ENABLE_YAML_CPP)
    download_project(
        PROJ yamlcpp
        GIT_REPOSITORY https://github.com/jbeder/yaml-cpp.git
        GIT_TAG yaml-cpp-0.6.3
        ${UPDATE_DISCONNECTED_IF_AVAILABLE}
    )

    set(YAML_CPP_BUILD_TESTS OFF CACHE BOOL "" FORCE)

    add_subdirectory(${yamlcpp_SOURCE_DIR} ${yamlcpp_BINARY_DIR} EXCLUDE_FROM_ALL)
    #include_directories(${yamlcpp_SOURCE_DIR}/include)
endif()

#
# ZeroMQ
if(ENABLE_ZMQ)
    download_project(
        PROJ libzmq
        GIT_REPOSITORY https://github.com/zeromq/libzmq.git
        GIT_TAG v4.3.2
        ${UPDATE_DISCONNECTED_IF_AVAILABLE}
    )

    set(WITH_PERF_TOOL OFF CACHE BOOL "Enables the build of performance tools. Default value is ON." FORCE)
    set(ZMQ_BUILD_TESTS OFF CACHE BOOL "Builds ZeroMQ tests. Default value is ON." FORCE)
    set(ENABLE_CPACK OFF CACHE BOOL "Enables CPack build rules. This option has effect on Windows platform only. Default value is ON." FORCE)

    add_subdirectory(${libzmq_SOURCE_DIR} ${libzmq_BINARY_DIR} EXCLUDE_FROM_ALL)

    #
    # cppzmq
    download_project(
        PROJ cppzmq
        GIT_REPOSITORY https://github.com/zeromq/cppzmq.git
        GIT_TAG v4.6.0
        ${UPDATE_DISCONNECTED_IF_AVAILABLE}
    )

    set(CPPZMQ_BUILD_TESTS OFF CACHE BOOL "Builds cppzmq tests. Default value is ON." FORCE)

    # when cannot find libzmq
    set(ZeroMQ_DIR ${libzmq_BINARY_DIR})

    add_subdirectory(${cppzmq_SOURCE_DIR} ${cppzmq_BINARY_DIR} EXCLUDE_FROM_ALL)

endif()
