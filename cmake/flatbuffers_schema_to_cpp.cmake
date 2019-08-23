# from flatbuffers' CMakeList.txt

# SRC_FBS is absoulte full path
function(compile_flatbuffers_schema_to_cpp_opt SRC_FBS OPT)
    get_filename_component(FBS_NAME ${SRC_FBS} NAME)
    get_filename_component(SRC_FBS_DIR ${SRC_FBS} DIRECTORY)
    get_filename_component(PARENT_DIR ${SRC_FBS_DIR} NAME)
    string(REGEX REPLACE "\\.fbs$" "_generated.h" GEN_HEADER "${PARENT_DIR}/${FBS_NAME}")
    message("** Flatbuffers schema to cpp")
    message(" - src: ${PARENT_DIR}/${FBS_NAME}")
    message(" - out: ${GEN_HEADER}")
    message(" - inc: ${CMAKE_CURRENT_BINARY_DIR}/${PARENT_DIR}")
    add_custom_command(
        OUTPUT ${GEN_HEADER}
        COMMAND flatc --cpp --gen-mutable --reflect-names ${OPT}
                -o ${PARENT_DIR}
                # --cpp-ptr-type flatbuffers::unique_ptr # Used to test with C++98 STLs
                # -I "${CMAKE_CURRENT_SOURCE_DIR}/tests/include_test"
                "${SRC_FBS}"
        DEPENDS flatc)
    include_directories(${CMAKE_CURRENT_BINARY_DIR}/${PARENT_DIR})
endfunction()

function(compile_flatbuffers_schema_to_cpp SRC_FBS)
    compile_flatbuffers_schema_to_cpp_opt(${SRC_FBS} "--gen-compare")
endfunction()
