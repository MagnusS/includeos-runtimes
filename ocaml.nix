{
  includeos
}:
    includeos.pkgsStatic.ocaml-ng.ocamlPackages_4_14.ocaml.overrideAttrs (old: {
      configureFlags = old.configureFlags ++ [ "--disable-systhreads" "--enable-mmap-map-stack" ];
    })
