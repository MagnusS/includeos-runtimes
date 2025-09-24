{
  withCcache ? false, # Enable ccache support
  smp ? false, # Enable SMP support
  includeos ? import ./includeos.nix { inherit smp; inherit withCcache; },
  myOcaml ? import ./ocaml.nix { inherit includeos; },
}:
let
  stdenv = includeos.stdenv;
  pkgs = includeos.pkgs;
  pkgsStatic = includeos.pkgsStatic;
in
pkgs.mkShell.override { inherit (includeos) stdenv; } rec {
  packages = [
    includeos.vmrunner
    stdenv.cc
    pkgsStatic.buildPackages.cmake
    pkgsStatic.buildPackages.nasm
    pkgsStatic.buildPackages.binutils
    pkgs.qemu
    pkgs.which
    pkgs.grub2
    pkgs.iputils
  ];

  buildInputs = [
    includeos
    includeos.chainloader
    myOcaml
  ];

  cmakeFlags = [
    "-DOCAML=${myOcaml}"
    "-DINCLUDEOS_PACKAGE=${includeos}"
    "-DFOR_PRODUCTION=off"
    "-DARCH=x86_64"
    "-DCMAKE_VERBOSE_MAKEFILE:BOOL=ON"
  ];

  bootloader="${includeos}/boot/bootloader";

  shellHook = ''
    echo "To build the hello_world unikernel:"
    echo " cmake src/CMakeLists.txt -B ./build $cmakeFlags"
    echo " cd ./build"
    echo " make"
    echo " boot ./hello.elf.bin"
  '';
}
