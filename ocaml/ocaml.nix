{
  includeos
}:
    includeos.pkgsStatic.ocaml-ng.ocamlPackages_5_3.ocaml.overrideAttrs (old: {
      configureFlags = old.configureFlags ++ [ "--disable-systhreads" "--enable-mmap-map-stack" "ac_cv_func_sigprocmask=no"];
    })
