{
  description = "flakez - Node 20.8"; # 1.21.1 to be exact

  inputs = {
    # Set this to the actual nixpkgs you are going to use
    nixpkgs.url = "github:NixOS/nixpkgs/d0829e587e66221a423a3cf261a9d81151c03caa";

    nodePkgs.url = "github:NixOS/nixpkgs/d0829e587e66221a423a3cf261a9d81151c03caa";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , nodePkgs
    , flake-utils
    } @ inputs: flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        nodePkgs' = nodePkgs.legacyPackages.${system};
        node = nodePkgs'.nodejs_20;
      in {
        defaultPackage = node;

        devShells.default = pkgs.mkShell {
          packages = [
            node
          ];

          shellHook = ''
            ${node}/bin/node --version
          '';
        };

        # For compatibility with older versions of the `nix` binary
        devShell = self.devShells.${system}.default;
      }
    );
}
