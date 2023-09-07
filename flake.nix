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
        packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

        packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

        devShell.x86_64-linux =
            (pkgs.mkShell.override {
              stdenv = (pkgs.overrideCC pkgs.stdenv cc);
            }){ buildInputs = [
              # LFS requirements
              pkgs.bash
              cc
              # pkgs.binutils-unwrapped # note this should be 2.40; should be ok
              
              # Personal additions
              pkgs.ripgrep
            ]; };
    };
}
