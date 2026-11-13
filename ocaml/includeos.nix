{
  withCcache ? false,
  smp ? false,
  pkgs ? import <nixpkgs> {}
}:
let
  src = builtins.fetchGit {
      url = "https://github.com/includeos/IncludeOS.git";
      ref = "main";
  };
  
  patched = pkgs.applyPatches {
    name = "includeos-patched";
    inherit src;
    patches = [
      ./includeos.patch
    ];
  };
in
  import patched { inherit withCcache smp; }

# to point to local checkout, use path to IncludeOS' default.nix:
# import (~/git/IncludeOS) { inherit withCcache; inherit smp; }
