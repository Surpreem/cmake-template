#define CATCH_CONFIG_MAIN

#include "catch2/catch.hpp"
#include "yaml-cpp/yaml.h"


TEST_CASE("Yaml-cpp")
{
    YAML::Node node = YAML::Load("[1, 2, 3]");
    REQUIRE(node.Type() == YAML::NodeType::Sequence);
    REQUIRE(node.IsSequence());  // a shortcut!
}
