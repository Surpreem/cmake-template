#
# example
add_executable(gtest_test example/gtest_test.cpp)
target_link_libraries(gtest_test gtest gmock_main)
add_test(NAME test_gtest COMMAND gtest_test)

add_executable(catch_test example/catch_test.cpp)
target_link_libraries(catch_test Catch2::Catch2)
add_test(NAME test_catch COMMAND catch_test)

add_executable(yaml_test example/yaml_test.cpp)
target_link_libraries(yaml_test Catch2::Catch2 yaml-cpp)
add_test(NAME test_yaml COMMAND yaml_test)
