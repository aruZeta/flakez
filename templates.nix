{
}:

let
  inherit (builtins)
    elem
    elemAt
    map
    attrNames
    readDir
    foldl'
    listToAttrs
    concatMap
    replaceStrings
    match
  ;
  filterAttrs = cond: set:
    listToAttrs (concatMap (name:
      let v = set.${name};
      in if cond name v
         then [{ name = name; value = v; }]
         else []
    ) (attrNames set));
  exceptions = [ ".git" ];
  filterDirs = let
    filterDir = name: type:
      type == "directory"
      && !(elem name exceptions);
    in files: filterAttrs filterDir files;
  toPath = path: path': path + ("/" + path');
  directoryAttrsToList = dirs: path: map (dir: toPath path dir) (attrNames dirs);
  readEnvDirs = path: directoryAttrsToList (filterDirs (readDir path)) path;
  readEnvDirs' = rec {
    f = path: acc:
      let
        envDirs = readEnvDirs path;
      in if envDirs == []
         then acc ++ [path]
         else foldl' (acc': path': f path' acc') acc envDirs;
  }.f;
in listToAttrs (map (path:
  let name = replaceStrings ["/"] ["_"]
    (elemAt (match (toString ./. + "/(.*)") (toString path)) 0);
  in {
    name = name;
    value = {
      path = path;
      description = "${replaceStrings ["_"] [" "] name} development environment";
    };
  }) (readEnvDirs' ./. []))
