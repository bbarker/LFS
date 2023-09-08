#
# Run with `nix develop -i --impure`;
# note the `-i` gives a more pure environment, but we currently need
# `--impure` to allow a config.nix to be read, permitting the use of
# xen (which as the time of this writing, has some known CVEs)
#

{
  description = "A flake for building LFS (Linux From Scratch)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.05";
  };
  
  outputs = { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      cc = pkgs.wrapCCWith rec {
        cc = pkgs.gcc-unwrapped;
        bintools = pkgs.wrapBintoolsWith {
          bintools = pkgs.binutils-unwrapped;
          libc = pkgs.glibc;
        };
      };      
    in {
      devShell.x86_64-linux =
        (pkgs.mkShell.override {
          stdenv = (pkgs.overrideCC pkgs.stdenv cc);
        }){
          buildInputs = [
            # LFS requirements
            pkgs.bash              
            # pkgs.binutils-unwrapped # should be part of stdenv above
            pkgs.bison
            pkgs.coreutils # TODO: do we need coreutils-full
            pkgs.diffutils
            pkgs.findutils
            pkgs.gawk
            # gcc included in stdenv
            pkgs.gnugrep
            pkgs.gzip
            pkgs.gnum4
            pkgs.gnumake
            pkgs.gnupatch
            pkgs.perl
            pkgs.python312
            pkgs.gnused
            pkgs.gnutar
            pkgs.texinfo
            pkgs.xz

            # Implicitly assumed by LFS
            pkgs.mount

            # VM and disk image utils
            pkgs.qemu_xen

            # Personal additions to ease development
            pkgs.ripgrep
            pkgs.git
          ];

          shellHook = ''
            source ./version-check.sh
          '';
        };
    };
}
