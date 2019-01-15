let
  channel = v: import (builtins.fetchTarball "https://nixos.org/channels/${v}/nixexprs.tar.xz") {};
  jellyfish = channel "nixos-18.09";
  unstable = channel "nixos-unstable";
in
{
  nix_2_1 = jellyfish.nix;
  nix_2_2 = jellyfish.nixUnstable;
  nix_stable_on_unstable = unstable.nix;
}
