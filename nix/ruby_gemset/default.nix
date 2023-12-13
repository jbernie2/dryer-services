{ name ? "gemset-nix-wat-wat"
  , gemfile
  , gemspec
  , ruby
  , bundler
  , bundix
  , lib
  , stdenv
}:
let

in
stdenv.mkDerivation {
  inherit name gemspec gemfile;
  buildInputs = [ruby bundler bundix ];
  phases = [ "buildPhase" ];
  buildPhase = ''
    echo "TMP = $TMP"
    echo "gemfile = $gemfile"
    echo "gemspec = $gemspec"
    echo "pwd = $PWD"

    cd $TMP
    cp $gemfile ./Gemfile
    cp $gemspec .
    bundler lock
    HOME=$TMP bundix --lock
    cat ./gemset.nix
    mkdir $out
    cp ./gemset.nix $out/gemset.nix
    cp ./Gemfile.lock $out/Gemfile.lock
    cp ./Gemfile $out/Gemfile
  '';
}

