#
# Run with `nix develop -i`; note the `-i` gives a more pure environment
#

{
  description = "A flake for building LFS (Linux From Scratch)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.05";
  };
  
  outputs = { self, nixpkgs }:
    let pkgs = nixpkgs.legacyPackages.x86_64-linux;  
    in {
        packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

        packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

        devShell.x86_64-linux =
            pkgs.mkShell { buildInputs = [
              # LFS requirements
              pkgs.bash
              # pkgs.binutils-unwrapped # note this should be 2.40; should be ok
              
              # Personal additions
              pkgs.ripgrep
            ]; };
    };
}
