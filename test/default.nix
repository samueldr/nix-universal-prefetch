{
  pkgs ? import <nixpkgs> {}
}:
let
  inherit (pkgs) lib ruby;
  nixes = import ./nixes.nix;
  script = lib.concatStrings (lib.mapAttrsToList
    (name: nix: ''
      echo
      echo "Testing ${name}"
      (
      PATH=${nix}/bin:$PATH
      nix-instantiate --version
      printf "\n\nSanity check:\n"
      ${ruby}/bin/ruby ${../nix-universal-prefetch} --help
      printf "\n\nbuiltins.fetchurl:\n"
      ${ruby}/bin/ruby ${../nix-universal-prefetch} builtins.fetchurl --url file:///dev/null
      printf "\n\nfixed output:\n"
      ${ruby}/bin/ruby ${../nix-universal-prefetch} --raw '${hello_fixed_output}'
      )
    '')
    nixes
  );
  # From nix's source, tests/common.sh.in
  nix_harness = ''
    export TEST_ROOT=$(realpath ''${TMPDIR:-/tmp}/nix-test)
    export NIX_STORE_DIR
    if ! NIX_STORE_DIR=$(readlink -f $TEST_ROOT/store 2> /dev/null); then
        # Maybe the build directory is symlinked.
        export NIX_IGNORE_SYMLINK_STORE=1
        NIX_STORE_DIR=$TEST_ROOT/store
    fi
    export NIX_LOCALSTATE_DIR=$TEST_ROOT/var
    export NIX_LOG_DIR=$TEST_ROOT/var/log/nix
    export NIX_STATE_DIR=$TEST_ROOT/var/nix
    export NIX_CONF_DIR=$TEST_ROOT/etc
    export _NIX_TEST_SHARED=$TEST_ROOT/shared
    if [[ -n $NIX_STORE ]]; then
        export _NIX_TEST_NO_SANDBOX=1
    fi
    export _NIX_TEST_NO_SANDBOX=1
    export _NIX_IN_TEST=$TEST_ROOT/shared
    export NIX_REMOTE=$NIX_REMOTE_
    unset NIX_PATH
    export TEST_HOME=$TEST_ROOT/test-home
    export HOME=$TEST_HOME
    unset XDG_CACHE_HOME
    mkdir -p $TEST_HOME

    # Adds a configuration file to, among others, disable the sandbox.
    mkdir -p "$NIX_CONF_DIR"
    cat > "$NIX_CONF_DIR"/nix.conf <<EOF
    keep-derivations = false
    sandbox = false
    EOF
  '';
  # Sandbox-friendly fixed-output derivation
  hello_fixed_output = ''
    let
      pkgs = import <nixpkgs> {};
    in {sha256}: derivation {
      inherit (pkgs) system;
      name = "test";
      builder = "/bin/sh";
      args = ["-c" "echo hi > $out"];
      outputHashMode = "flat";
      outputHashAlgo = "sha256";
      outputHash = sha256;
    }
  '';
in
  pkgs.runCommand "log.txt" {} ''
    ${nix_harness}
    export NIX_PATH=nixpkgs=${pkgs.path}

    (
    ${script}
    ) 2>&1 | tee $out
  ''
