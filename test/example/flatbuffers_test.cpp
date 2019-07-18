#define CATCH_CONFIG_MAIN

#include <cassert>
#include <iostream>
#include <string>
#include <vector>

#include "catch2/catch.hpp"

#include "monster_generated.h"


using namespace MyGame::Sample;

TEST_CASE("flatbuffers")
{
    // Given
    flatbuffers::FlatBufferBuilder builder{1024};

    auto weapon_one_name{builder.CreateString("Sword")};
    auto weapon_one_damage{static_cast<short>(3)};

    auto weapon_two_name{builder.CreateString("Axe")};
    auto weapon_two_damage{static_cast<short>(5)};

    auto sword{CreateWeapon(builder, weapon_one_name, weapon_one_damage)};
    auto axe{CreateWeapon(builder, weapon_two_name, weapon_two_damage)};

    std::vector<flatbuffers::Offset<Weapon>> weapons_vector;
    weapons_vector.push_back(sword);
    weapons_vector.push_back(axe);
    auto weapons{builder.CreateVector(weapons_vector)};


    auto position{Vec3{1.0f, 2.0f, 3.0f}};

    auto name{builder.CreateString("Orc")};

    unsigned char treasure[]{0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
    auto inventory{builder.CreateVector(treasure, 10)};

    Vec3 points[]{Vec3{1.0f, 2.0f, 3.0f}, Vec3{4.0f, 5.0f, 6.0f}};
    auto path{builder.CreateVectorOfStructs(points, 2)};

    auto hp{static_cast<short>(300)};
    auto mana{static_cast<short>(150)};

    auto orc{CreateMonster(
        builder,
        &position,
        mana,
        hp,
        name,
        inventory,
        Color_Red,
        weapons,
        Equipment_Weapon,
        axe.Union(),
        path)};

    builder.Finish(orc);    // FinishMonster(builder, orc);

    // When
    auto monster{GetMonster(builder.GetBufferPointer())};

    // Then
    REQUIRE(300 == monster->hp());
    REQUIRE(150 == monster->mana());
    REQUIRE("Orc" == monster->name()->str());

    auto pos{monster->pos()};
    REQUIRE(3.0f == pos->z());

    auto inv{monster->inventory()};
    REQUIRE(10 == inv->size());
    REQUIRE(2 == inv->Get(2));

    std::string expected_weapon_names[]{"Sword", "Axe"};
    short expected_weapon_damages[]{3, 5};
    auto wps{monster->weapons()};
    for (auto i{0u}; wps->size() != i; ++i) {
        REQUIRE(expected_weapon_names[i] == wps->Get(i)->name()->str());
        REQUIRE(expected_weapon_damages[i] == wps->Get(i)->damage());
    }

    auto union_type{monster->equipped_type()};
    if (Equipment_Weapon == union_type) {
        auto equipped{static_cast<Weapon const*>(monster->equipped())};
        REQUIRE("Axe" == equipped->name()->str());
        REQUIRE(5 == equipped->damage());
    }
}
