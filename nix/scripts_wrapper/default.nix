{pkgs, name, scripts, buildInputs}:
let
  createExecutable = script:
    (
      pkgs.writeScriptBin script.name (builtins.readFile script.file)
    ).overrideAttrs(old: {
      buildCommand = "${old.buildCommand}\n patchShebangs $out";
    });

  wrappedScripts = pkgs.symlinkJoin {
    name = name;
    paths = (builtins.map createExecutable scripts) ++ buildInputs;
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = postBuild;
  };

  postBuild = pkgs.lib.concatStrings (builtins.map wrapProgram scripts);
  wrapProgram = script: "wrapProgram $out/bin/${script.name} --prefix PATH : $out/bin ;";
in
  wrappedScripts
