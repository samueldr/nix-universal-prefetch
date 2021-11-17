{ pkgs ? import <nixpkgs> {} }:

let
  inherit (pkgs) runCommand ruby;
  version = "0.4.0";
in
# The main script uses nix-shell, for quick iteration or one-off use without building.
# I find it simpler to just prefix the shebang I want.
runCommand "nix-universal-prefetch-${version}" {} ''
  mkdir -pv $out/bin
  cp ${./nix-universal-prefetch} $out/bin/nix-universal-prefetch
  substituteInPlace "$out/bin/nix-universal-prefetch" \
    --replace "/usr/bin/env nix-shell" "${ruby}/bin/ruby"
''
