﻿#
# example
if(ENABLE_CATCH AND ENABLE_BOOST)
    add_executable(boost_test example/boost_test.cpp)
    target_link_libraries(boost_test PRIVATE Catch2::Catch2)
    add_test(NAME test_boost COMMAND boost_test)
endif()

if(ENABLE_CATCH)
    add_executable(catch_test example/catch_test.cpp)
    target_link_libraries(catch_test PRIVATE Catch2::Catch2)
    add_test(NAME test_catch COMMAND catch_test)
endif()

if(ENABLE_CATCH AND ENABLE_FLATBUFFERS)
    # full path to fbs
    compile_flatbuffers_schema_to_cpp(${TEST_PATH}/example/fbs/monster.fbs)

    # need to generate the header and build the project
    set(fbs_generated
        ${CMAKE_CURRENT_BINARY_DIR}/fbs/monster_generated.h)

    add_executable(flatbuffers_test
        ${fbs_generated}
        example/flatbuffers_test.cpp)
    target_link_libraries(flatbuffers_test PRIVATE Catch2::Catch2 flatbuffers)
    add_test(NAME test_flatbuffers COMMAND flatbuffers_test)
endif()

if(ENABLE_GOOGLE_TEST)
    add_executable(gtest_test example/gtest_test.cpp)
    target_link_libraries(gtest_test PRIVATE gtest gmock_main)
    add_test(NAME test_gtest COMMAND gtest_test)
endif()

if(ENABLE_CATCH AND ENABLE_SPDLOG)
    add_executable(spdlog_test example/spdlog_test.cpp)

    if(SPDLOG_MAKE_LIB)
        target_link_libraries(spdlog_test PRIVATE Catch2::Catch2 spdlog::spdlog)
    else()
        target_link_libraries(spdlog_test PRIVATE Catch2::Catch2 spdlog::spdlog_header_only)
    endif()

    add_test(NAME test_spdlog COMMAND spdlog_test)
endif()

if(ENABLE_CATCH AND ENABLE_YAML_CPP)
    add_executable(yaml_test example/yaml_test.cpp)
    target_link_libraries(yaml_test PRIVATE Catch2::Catch2 yaml-cpp)
    add_test(NAME test_yaml COMMAND yaml_test)
endif()

if(ENABLE_CATCH AND ENABLE_ZMQ)
    add_executable(zmq_test example/zmq_test.cpp)
    target_link_libraries(zmq_test PRIVATE Catch2::Catch2 cppzmq)
    add_test(NAME test_zmq COMMAND zmq_test)
endif()
