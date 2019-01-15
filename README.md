`nix-universal-prefetch`
========================

This uses nix and nixpkgs to actually run the prefetch operation, then
read the error message to figure out the desired hash.

The output is *only* of the hash when it works, allowing it to be (ab)used
in an automated manner.

When another error happens, the standard error output will be printed.

Installing
----------

```
git clone https://github.com/samueldr/nix-universal-prefetch.git
cd nix-universal-prefetch
nix-env -if .
```

Testing
-------

```
.../nix-universal-prefetch $ nix-build ./test
```


Limitations
-----------

It cannot print the *complete* list of arguments for composed fetchers (most fetchers are composed).

However, passing those unlisted additional arguments to those fetchers will work.

* * *

Example
-------

```
 $ nix-universal-prefetch -l
Fetchers:
 - fetchCrate
 - fetchDockerConfig
 - fetchDockerLayer
 - fetchFromBitbucket
 - fetchFromGitHub
 - fetchFromGitLab
 - fetchFromRepoOrCz
 - fetchFromSavannah
 - fetchHex
 - fetchMavenArtifact
 - fetchNuGet
 - fetchRepoProject
 - fetchbower
 - fetchbzr
 - fetchcvs
 - fetchdarcs
 - fetchdocker
 - fetchegg
 - fetchfossil
 - fetchgit
 - fetchgitLocal
 - fetchgitPrivate
 - fetchgx
 - fetchhg
 - fetchipfs
 - fetchmtn
 - fetchpatch
 - fetchs3
 - fetchsvn
 - fetchsvnrevision
 - fetchsvnssh
 - fetchurl
 - fetchurlBoot
 - fetchzip

 $ nix-universal-prefetch fetchFromGitHub --help
fetchFromGitHub: [options]
        --fetchSubmodules=VALUE
        --githubBase=VALUE
        --name=VALUE
        --owner=VALUE
        --private=VALUE
        --repo=VALUE
        --rev=VALUE
        --varPrefix=VALUE

 $ nix-universal-prefetch fetchFromGitHub --owner NixOS --repo nixpkgs
error: 'fetchFromGitHub' at /etc/nixos/nixpkgs/pkgs/top-level/all-packages.nix:236:21 called without required argument 'rev', at (string):1:2

 $ nix-universal-prefetch fetchFromGitHub --owner NixOS --repo nixpkgs --rev master
04i1xrzyl3i3b1kmfx6f5z78sc66hwzyxd3v6i4zfqavvarw3w6s

```
