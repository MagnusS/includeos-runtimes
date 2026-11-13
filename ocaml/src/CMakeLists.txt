cmake_minimum_required(VERSION 3.0)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
set(CMAKE_LINKER_TYPE LLD)

project (hello_ocaml)

include("${INCLUDEOS_PACKAGE}/cmake/os.cmake")

#os_add_drivers(hello virtionet vmxnet3 boot_logger)

add_custom_command(OUTPUT ocamlcode.o
  COMMAND cd ${CMAKE_CURRENT_SOURCE_DIR} && ${OCAML}/bin/ocamlopt -g -c test_ocaml.ml -o ${CMAKE_CURRENT_BINARY_DIR}/test_ocaml.cmx
  COMMAND ${OCAML}/bin/ocamlopt -output-obj -g -o ${CMAKE_CURRENT_BINARY_DIR}/ocamlcode.o ${CMAKE_CURRENT_BINARY_DIR}/test_ocaml.cmx)

add_library(ocamlcode
	STATIC
	ocamlcode.o)

SET_SOURCE_FILES_PROPERTIES(
	ocamlcode.o
	PROPERTIES
	EXTERNAL_OBJECT true
	GENERATED true
)

SET_TARGET_PROPERTIES(
	ocamlcode
	PROPERTIES
	LINKER_LANGUAGE C
)

set(LIB_ASMRUN ${OCAML}/lib/ocaml/libasmrun.a)
add_library(asmrun STATIC IMPORTED GLOBAL)
set_target_properties(asmrun
    PROPERTIES
    IMPORTED_LOCATION ${LIB_ASMRUN})

os_add_executable(hello "Hello world - OS included" main.cpp ocamlcode.o)
os_add_stdout(hello default_stdout)
os_link_libraries(hello asmrun)
os_include_directories(hello PRIVATE ${OCAML}/lib/ocaml)
#target_link_libraries(${ELF_TARGET} PRIVATE asmrun)

set(BINARY_NAME hello)
set(ELF_TARGET ${BINARY_NAME}${ELF_POSTFIX})

install(TARGETS ${ELF_TARGET} DESTINATION bin)
