#
# Run with `nix develop -i`; note the `-i` gives a more pure environment
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
            # pkgs.binutils-unwrapped # should be part of stdenv above and ok at 2.40
            pkgs.bison
            pkgs.coreutils # TODO: do we need coreutils-full
            pkgs.diffutils
            pkgs.findutils
            pkgs.gawk
            # gcc included in stdenv; should be ok at 12.2.0
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

            # Personal additions
            pkgs.ripgrep
            pkgs.git
          ];

          shellHook = ''
            source ./version-check.sh
          '';
        };
    };
}
