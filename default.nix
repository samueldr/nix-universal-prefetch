{ pkgs ? import <nixpkgs> {} }:

let
  inherit (pkgs) runCommand ruby;
  version = "0.0.1";
in
# The main script uses nix-shell, for quick iteration or one-off use without building.
# I find it simpler to just prefix the shebang I want.
runCommand "nix-universal-prefetch-${version}" {} ''
  mkdir -pv $out/bin
  echo "#!${ruby}/bin/ruby" > $out/bin/nix-universal-prefetch
  cat ${./nix-universal-prefetch} >> $out/bin/nix-universal-prefetch
  chmod +x $out/bin/nix-universal-prefetch
''
