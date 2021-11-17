let
  channel = v: import (builtins.fetchTarball "https://nixos.org/channels/${v}/nixexprs.tar.xz") {};
  markhor = channel "nixos-20.03";
  unstable = channel "nixos-unstable";
in
{
  nix_2_3 = markhor.nix;
  nix_stable_on_unstable = unstable.nix;
  nix_unstable_on_unstable = unstable.nixUnstable;
}
