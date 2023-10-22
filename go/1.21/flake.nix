{
  description = "flakez - Go 1.21"; # 1.21.1 to be exact

  inputs = {
    # Set this to the actual nixpkgs you are going to use
    nixpkgs.url = "github:NixOS/nixpkgs/e67b7b6ab5e1c8055597d5c02ad6d3c489f0f134";

    goPkgs.url = "github:NixOS/nixpkgs/e67b7b6ab5e1c8055597d5c02ad6d3c489f0f134";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , goPkgs
    , flake-utils
    } @ inputs: flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        go = goPkgs.legacyPackages.${system}.go_1_21;
      in {
        defaultPackage = go;

        devShells.default = pkgs.mkShell {
          packages = [
            go
          ];

          shellHook = ''
            ${go}/bin/go version
          '';
        };

        # For compatibility with older versions of the `nix` binary
        devShell = self.devShells.${system}.default;
      }
    );
}
