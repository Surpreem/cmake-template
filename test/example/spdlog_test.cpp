#define CATCH_CONFIG_MAIN

#include <fstream>
#include <string>

#include "catch2/catch.hpp"
#include "spdlog/sinks/basic_file_sink.h"


using namespace std;


namespace {
    
    const std::string log_file{"log.txt"};

}


TEST_CASE("spdlog")
{
    // GIVEN
    auto logger{spdlog::basic_logger_mt("basic_logger", log_file)};

    // WHEN
    logger->info("Hello, {}!", "World");

    // THEN
    ifstream fin(log_file);
    string log;
    getline(fin, log);

    REQUIRE(string::npos != log.find("[info] Hello, World!"));
}
