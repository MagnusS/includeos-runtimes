{
  withCcache ? false,
  smp ? false,
}:
import (builtins.fetchGit {
      url = "https://github.com/includeos/IncludeOS.git";
      ref = "main";
}) { inherit withCcache; inherit smp; }

# to point to local checkout, use path to IncludeOS' default.nix:
# import (~/git/IncludeOS) { inherit withCcache; inherit smp; }
