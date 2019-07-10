#define CATCH_CONFIG_MAIN

#include "boost/thread.hpp"
#include "catch2/catch.hpp"


TEST_CASE("boost.thread")
{
    // GIVEN
    auto value{0};

    // WHEN
    auto t{boost::thread{[&value] {
        for (auto i{0}; 10 != i; ++i)
            ++value;
    }}};

    t.join();

    // THEN
    REQUIRE(10 == value);
}
