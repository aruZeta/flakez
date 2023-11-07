{
  description = "flakez - Java 17";

  inputs = {
    # Set this to the actual nixpkgs you are going to use
    nixpkgs.url = "github:NixOS/nixpkgs/82c294f13af5b364083f6043a6b0ac8a4581cfc2";

    javaPkgs.url = "github:NixOS/nixpkgs/82c294f13af5b364083f6043a6b0ac8a4581cfc2";
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
        java = javaPkgs.legacyPackages.${system}.jdk17;
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
