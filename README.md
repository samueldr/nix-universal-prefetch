`nix-universal-prefetch`
========================

This uses nix and nixpkgs to actually run the prefetch operation, then
read the error message to figure out the desired hash.

The output is *only* of the hash when it works, allowing it to be (ab)used
in an automated manner.

When another error happens, the standard error output will be printed.
