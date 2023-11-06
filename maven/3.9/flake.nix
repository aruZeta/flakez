{
  description = "flakez - Maven 3.9"; # 3.9.5 to be exact

  inputs = {
    # Set this to the actual nixpkgs you are going to use
    nixpkgs.url = "github:NixOS/nixpkgs/447f9d611da6a6ee5a54c75033684591bf25e101";

    mavenPkgs.url = "github:NixOS/nixpkgs/447f9d611da6a6ee5a54c75033684591bf25e101";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , mavenPkgs
    , flake-utils
    } @ inputs: flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        maven = mavenPkgs.legacyPackages.${system}.maven;
      in {
        defaultPackage = maven;

        devShells.default = pkgs.mkShell {
          packages = [
            maven
          ];

          shellHook = ''
            ${maven}/bin/mvn --version
          '';
        };

        # For compatibility with older versions of the `nix` binary
        devShell = self.devShells.${system}.default;
      }
    );
}
