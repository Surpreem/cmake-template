#include "gtest/gtest.h"
#include "gmock/gmock.h"


// Simple test, does not use gmock
TEST(Dummy, foobar)
{
    EXPECT_EQ(1, 1);
}


// Real class we want to mock
class TeaBreak
{
public:
    virtual ~TeaBreak() {}

    // Return minutes taken to make the drinks
    int morning_tea()
    {
        return make_coffee(true,  1) +
               make_coffee(false, 0.5) +
               make_herbal_tea();
    }

private:
    virtual int make_coffee(bool milk, double sugars) = 0;
    virtual int make_herbal_tea() = 0;
};

// Mock class
class MockTeaBreak : public TeaBreak
{
public:
    MOCK_METHOD2(make_coffee, int(bool milk, double sugars));
    MOCK_METHOD0(make_herbal_tea, int());
};


using ::testing::Return;
using ::testing::_;

// Mocked test
TEST(TeaBreakTest, MorningTea)
{
    MockTeaBreak  tea_break;
    EXPECT_CALL(tea_break, make_coffee(_,_))
        .WillOnce(Return(2))
        .WillOnce(Return(1));
    EXPECT_CALL(tea_break, make_herbal_tea())
        .WillOnce(Return(3));

    EXPECT_LE(tea_break.morning_tea(), 6);
}
