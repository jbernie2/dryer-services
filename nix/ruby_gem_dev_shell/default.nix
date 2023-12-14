{ name ? "ruby-gem-dev-shell"
  # user supplied
  , project_root
  , gemspec

  # from nix packages
  , callPackage
  , bundlerEnv
  , mkShell
  , ruby
  , bundler
  , bundix
  , git
  , gh
  , libpcap
  , libxml2
  , libxslt
  , pkg-config
  , gnumake
  , libyaml
  , which
}:
let
  buildGemset = callPackage ./ruby_gemset { src = project_root; };
  gemsetPath = "${buildGemset.outPath}/gemset.nix";
  lockfilePath = "${buildGemset.outPath}/Gemfile.lock";
  gemfilePath = "${buildGemset.outPath}/Gemfile";

  gems = bundlerEnv {
    name = "dryer-services-gems";
    gemfile = gemfilePath;
    gemset = gemsetPath;
    lockfile = lockfilePath;
    extraConfigPaths = [gemspec];
  };

  wrappedScripts = (callPackage 
    ./scripts_wrapper
    {
      name = "gem_scripts";
      scripts = [
        {
          name = "release_to_github";
          file = ./scripts/release_to_github.sh;
        }
        {
          name = "release_to_rubygems";
          file = ./scripts/release_to_rubygems.sh;
        }
        {
          name = "assert_env_var.sh";
          file = ./scripts/assert_env_var.sh;
        }
        {
          name = "assert_arg.sh";
          file = ./scripts/assert_arg.sh;
        }
      ];
      buildInputs = [ ruby gh bundler bundix ];
    }
  );

in
  mkShell {
    packages = [
      gems
      gems.wrappedRuby
    ];
    buildInputs = [
      git
      libpcap
      libxml2
      libxslt
      pkg-config
      bundix
      gnumake
      libyaml
      which
      wrappedScripts
    ];
    shellHook = ''
      cp -f result/gemset.nix result/Gemfile.lock .
    '';
  }
