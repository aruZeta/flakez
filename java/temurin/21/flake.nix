{
  description = "flakez - Java Temurin 21";

  inputs = {
    # Set this to the actual nixpkgs you are going to use
    nixpkgs.url = "github:NixOS/nixpkgs/d849c98d87af6bde4f56ee5207d648df65cc43ad";

    javaPkgs.url = "github:NixOS/nixpkgs/d849c98d87af6bde4f56ee5207d648df65cc43ad";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , javaPkgs
    , flake-utils
    } @ inputs: flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        java = javaPkgs.legacyPackages.${system}.temurin-bin-21;
      in {
        defaultPackage = java;

        devShells.default = pkgs.mkShell {
          packages = [
            java
          ];

          shellHook = ''
            ${java}/bin/java --version
          '';
        };

        # For compatibility with older versions of the `nix` binary
        devShell = self.devShells.${system}.default;
      }
    );
}
