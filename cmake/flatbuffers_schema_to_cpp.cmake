# from flatbuffers' CMakeList.txt

function(compile_flatbuffers_schema_to_cpp_opt SRC_FBS OPT)
    get_filename_component(SRC_FBS_DIR ${SRC_FBS} PATH)
    string(REGEX REPLACE "\\.fbs$" "_generated.h" GEN_HEADER ${SRC_FBS})
    add_custom_command(
        OUTPUT ${GEN_HEADER}
        COMMAND flatc -c --gen-mutable
                -o ${SRC_FBS_DIR}
                # --cpp-ptr-type flatbuffers::unique_ptr # Used to test with C++98 STLs
                --reflect-names ${OPT}
                # -I "${CMAKE_CURRENT_SOURCE_DIR}/tests/include_test"
                "${CMAKE_CURRENT_SOURCE_DIR}/${SRC_FBS}"
        DEPENDS flatc)
    include_directories(${CMAKE_CURRENT_BINARY_DIR}/${SRC_FBS_DIR})
endfunction()

function(compile_flatbuffers_schema_to_cpp SRC_FBS)
    compile_flatbuffers_schema_to_cpp_opt(${SRC_FBS} "--no-includes;--gen-compare")
endfunction()
