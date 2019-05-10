#define CATCH_CONFIG_MAIN

#include "catch2/catch.hpp"
#include "catch2/trompeloeil.hpp"


using namespace trompeloeil;


// Simple test, does not use mock
TEST_CASE("Dummy")
{
    REQUIRE(1 == 1);
}


// Real class we want to mock
class TeaBreak {
public:
    virtual ~TeaBreak()
    {}

    // Return minutes taken to make the drinks
    int morning_tea()
    {
        return make_coffee(true, 1) +
            make_coffee(false, 0.5) +
            make_herbal_tea();
    }

private:
    virtual int make_coffee(bool milk, double sugars) = 0;
    virtual int make_herbal_tea() = 0;
};

// Mock class
class MockTeaBreak : public TeaBreak {
public:
    MAKE_MOCK2(make_coffee, int(bool milk, double sugars));
    MAKE_MOCK0(make_herbal_tea, int());
};


// Mocked test
TEST_CASE("TeaBreakTest")
{
    MockTeaBreak  tea_break;

    REQUIRE_CALL(tea_break, make_coffee(eq(true), _))
        .RETURN(2).TIMES(1);
    REQUIRE_CALL(tea_break, make_coffee(eq(false), _))
        .RETURN(1).TIMES(1);
    REQUIRE_CALL(tea_break, make_herbal_tea())
        .RETURN(3).TIMES(1);

    REQUIRE(tea_break.morning_tea() <= 6);
}
