#define CATCH_CONFIG_MAIN

#include "catch2/catch.hpp"
#include "zmq_addon.hpp"


namespace {

    constexpr auto message_count{2};

}


TEST_CASE("ZeroMQ")
{
    // Given
    zmq::context_t ctx;
    zmq::socket_t sock1(ctx, zmq::socket_type::pair);
    zmq::socket_t sock2(ctx, zmq::socket_type::pair);
    sock1.bind("inproc://test");
    sock2.connect("inproc://test");

    // When
    std::array<zmq::const_buffer, message_count> send_msgs = {
        zmq::str_buffer("foo"),
        zmq::str_buffer("bar!")
    };
    zmq::send_multipart(sock1, send_msgs);

    std::vector<zmq::message_t> recv_msgs;
    const auto ret = zmq::recv_multipart(
        sock2, std::back_inserter(recv_msgs));

    // Then
    REQUIRE(message_count == *ret);
}
