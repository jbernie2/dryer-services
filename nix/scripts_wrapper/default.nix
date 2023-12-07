{ pkgs, scripts}:
let
  createExecutable = script:
    (
      pkgs.writeScriptBin script.name (builtins.readFile script.file)
    ).overrideAttrs(old: {
      buildCommand = "${old.buildCommand}\n patchShebangs $out";
    });

  wrapScript = script:
    {
      "${script.name}" = pkgs.symlinkJoin {
        name = script.name;
        paths = [ (createExecutable script) ] ++ script.buildInputs;
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = "wrapProgram $out/bin/${script.name} --prefix PATH : $out/bin";
      };
    };
in
  pkgs.lib.attrsets.mergeAttrsList (builtins.map wrapScript scripts)


        #pkgs = import nixpkgs { inherit system; };
        #my-name = "my-script";
        #my-buildInputs = with pkgs; [ cowsay ddate ];
        #my-script = (pkgs.writeScriptBin my-name (builtins.readFile ./simple-script.sh)).overrideAttrs(old: {
          #buildCommand = "${old.buildCommand}\n patchShebangs $out";
        #});
      #in rec {
        #defaultPackage = packages.my-script;
        #packages.my-script = pkgs.symlinkJoin {
          #name = my-name;
          #paths = [ my-script ] ++ my-buildInputs;
          #buildInputs = [ pkgs.makeWrapper ];
          #postBuild = "wrapProgram $out/bin/${my-name} --prefix PATH : $out/bin";
        #};
      #}
