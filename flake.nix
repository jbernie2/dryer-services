{
  description = "ruby gem development environment";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
    nix-filter.url = "github:numtide/nix-filter";
  };

  outputs = { self, nixpkgs, flake-utils, nix-filter }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      overlays = [
        (final: prev: {
          ruby = final.ruby_3_0;
        })
      ];
      pkgs = import nixpkgs { inherit system overlays; };

      wrappedScripts = (pkgs.callPackage 
        ./nix/scripts_wrapper
        {
          name = "gem_scripts";
          scripts = [
            {
              name = "update_deps";
              file = ./scripts/bundle.sh;
            }
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
          buildInputs = [ pkgs.ruby pkgs.gh pkgs.bundler pkgs.bundix ];
        }
      );

    in with pkgs;
      rec {
        devShells = rec {
          default = run;
          run = mkShell {
            buildInputs = [
              ruby.devEnv
              git
              libpcap
              libxml2
              libxslt
              pkg-config
              bundix
              gnumake
              libyaml
              which
            ];
          };
        };
        packages = rec {
          default = packages.${wrappedScripts.name};
          "${wrappedScripts.name}" = wrappedScripts;
        };
      }
    );
}
