{ name ? "gemset-nix"
  , src
  , ruby
  , bundler
  , bundix
  , lib
  , stdenv
}:
let

in
stdenv.mkDerivation {
  inherit name src;
  buildInputs = [ruby bundler bundix ];
  buildPhase = ''
    rm -f Makefile # don't want this to be accidentally used by nix stdenv
    bundler lock
    HOME=$TMP bundix --lock
  '';

  installPhase = ''
    mkdir $out
    cp ./gemset.nix $out/gemset.nix
    cp ./Gemfile.lock $out/Gemfile.lock
    cp ./Gemfile $out/Gemfile
  '';
}

