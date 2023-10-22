{ repo
}:

[
  { name = "use";
    scriptName = "flakez-use";
    script = ''
      IFS_BAK="$IFS"
      IFS='/'
      FLAKEZ_PATH="$*"
      IFS="$IFS_BAK"
      echo "use flake \"${repo}?dir=$FLAKEZ_PATH\"" >> .envrc
      direnv allow
    '';
  }
]
