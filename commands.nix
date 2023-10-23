{ repo
}:

let
  utils = {
    joinParams = sep: ''
      IFS_BAK="$IFS"
      IFS='${sep}'
      FLAKEZ_PARAMS="$*"
      IFS="$IFS_BAK"
    '';
  };
in

[
  { name = "use";
    scriptName = "flakez-use";
    script = ''
      ${utils.joinParams "/"}
      echo "use flake \"${repo}?dir=$FLAKEZ_PARAMS\"" >> .envrc
      direnv allow
    '';
  }

  { name = "init";
    scriptName = "flakez-init";
    script = ''
      ${utils.joinParams "_"}
      nix flake init --debug -v -t "${repo}#\"$FLAKEZ_PARAMS\""
      direnv allow
    '';
  }
]
