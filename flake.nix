{
  description = "flakez - utils";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    } @ inputs: flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (builtins)
          foldl'
          listToAttrs
          map
        ;
        inherit (pkgs.lib)
          nameValuePair
        ;
        repo = "github:aruZeta/flakez";
        flakez = rec {
          commands =
            let
              toCommandWithName = name: scriptName: script:
                {
                  name = name;
                  scriptName = scriptName;
                  deriv = pkgs.writeShellScriptBin scriptName script;
                };
              toCommandWithNameList = commands:
                map (c: (toCommandWithName c.name c.scriptName c.script)) commands;
            in toCommandWithNameList (import ./commands.nix {inherit repo;});
          main =
            let
              toCommand = command: ''
                elif [ "$CMD" = "${command.name}" ]; then
                  ${command.deriv}/bin/${command.scriptName} "$@"
              '';
            in pkgs.writeShellScriptBin "flakez" ''
              CMD=$1
              shift
              echo $CMD
              ${(foldl' (acc: curr: acc + (toCommand curr)) ''
                if [ -z "$CMD" ]; then
                  echo "No command passed" >&2
                  exit 1
              '' commands) + ''
                else
                  echo "Unknown command '$CMD'" >&2
                  exit 1
                fi
              ''}
          '';
        };
      in {
        packages = listToAttrs (map (c: nameValuePair c.name c.deriv) flakez.commands);
        defaultPackage = flakez.main;

        devShells.default = pkgs.mkShell {
          packages = [
            flakez.main
          ];
        };

        # For compatibility with older versions of the `nix` binary
        devShell = self.devShells.${system}.default;
      }
    );
}
