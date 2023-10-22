{ repo
}:

let
  utils = {
    paramsAsPath = ''
      IFS_BAK="$IFS"
      IFS='/'
      FLAKEZ_PATH="$*"
      IFS="$IFS_BAK"
    '';
  };
in

[
  { name = "use";
    scriptName = "flakez-use";
    script = ''
      ${utils.paramsAsPath}
      echo "use flake \"${repo}?dir=$FLAKEZ_PATH\"" >> .envrc
      direnv allow
    '';
  }

  { name = "init";
    scriptName = "flakez-init";
    script = ''
      ${utils.paramsAsPath}
      nix flake init -t "${repo}?dir=$FLAKEZ_PATH"
      direnv allow
    '';
  }
]
