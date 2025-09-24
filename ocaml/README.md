# IncludeOS + OCaml

Builds and boots a unikernel that runs OCaml code (w/effects) on top of IncludeOS.

Currently requires a patched IncludeOS. See [patch in root directory](./includeos.patch). The patch has to be applied manually and [includeos.nix](./includeos.nix) can be modified to point to the patched source code. Then run `nix-build`. This will compile ocaml against includeos/custom musl, link in the ocaml code and build the bootable unikernel.

Steps involved (only patch is manual, step 2-5 is handled in nix):
1. Patch IncludeOS to ignore unsupported mmap flags (this may not produce correct behaviour!)
2. Build custom ocaml without signals, threads and malloc (uses mmap instead) using IncludeOS' toolchain -- see [ocaml.nix](./ocaml.nix)
3. Build IncludeOS unikernel that includes C code to invoke the OCaml runtime -- see [./src/main.cpp](./src/main.cpp) and [./src/test.c](./src/test.c).
4. Build OCaml 5.3 effects example in pure OCaml code. There's an `entry ()` function used to redirect control -- see [./src/test_ocaml.ml](./src/test_ocaml.ml).
5. Link it all together and make bootable elf bin

The current [OCaml test code](./src/test_ocaml.ml) runs one of the examples from [ocaml-multicore/effects-examples](https://github.com/ocaml-multicore/effects-examples). Other examples should also work.

Known limitations:
- stdin is not working (bad file descriptor from includeos)
- stdout needs to be flushed if there's no newline. Some effects examples may require "flush stdout;" to be added after printf.
- this is not well tested yet, expect things to break :-)

Expected output:
```
[IncludeOS boot output...]
Hello world from IncludeOS main
Starting number 0
Forking number 1
Starting number 1
Forking number 3
Starting number 3
Yielding in number 3
Forking number 2
Starting number 2
Forking number 5
Starting number 5
Yielding in number 5
Forking number 4
Starting number 4
Yielding in number 4
Resumed number 3
Finishing number 3
Finishing number 0
Forking number 6
Starting number 6
Yielding in number 6
Resumed number 5
Finishing number 5
Finishing number 1
Resumed number 4
Finishing number 4
Finishing number 2
Resumed number 6
Finishing number 6
```
