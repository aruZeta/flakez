{
  description = "flakez - Gradle 8.4";

  inputs = {
    # Set this to the actual nixpkgs you are going to use
    nixpkgs.url = "github:NixOS/nixpkgs/730328a32145b4520108958c71d300a86648c0a1";

    gradlePkgs.url = "github:NixOS/nixpkgs/730328a32145b4520108958c71d300a86648c0a1";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , gradlePkgs
    , flake-utils
    } @ inputs: flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        gradle = gradlePkgs.legacyPackages.${system}.gradle;
      in {
        defaultPackage = gradle;

        devShells.default = pkgs.mkShell {
          packages = [
            gradle
          ];

          shellHook = ''
            ${gradle}/bin/gradle --version
          '';
        };

        # For compatibility with older versions of the `nix` binary
        devShell = self.devShells.${system}.default;
      }
    );
}
