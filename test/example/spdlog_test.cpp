#define CATCH_CONFIG_MAIN

#ifdef WIN32
// spdlog
// warning C4566: character cannot be represented in the current code page (949)
// warning C4819: The file contains a character that cannot be represented
//                in the current code page (949).
#   pragma warning(disable: 4566 4819)
#endif

#include <fstream>
#include <string>

#include "catch2/catch.hpp"
#include "spdlog/spdlog.h"
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
    logger->flush();

    // THEN
    ifstream fin(log_file);
    string log;
    getline(fin, log);

    REQUIRE(string::npos != log.find("[info] Hello, World!"));
}
