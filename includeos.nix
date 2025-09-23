{
  withCcache ? false,
  smp ? false,
}:
import (builtins.fetchGit {
      url = "https://github.com/includeos/IncludeOS.git";
      ref = "main";
}) { inherit withCcache; inherit smp; }
