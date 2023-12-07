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
      packageOverlays = [
        (final: prev: {
          ruby = final.ruby_3_0;
        })
      ];

      pkgs = import nixpkgs {
        system = system;
        overlays = packageOverlays;
      };

      scripts = [
        {
          name = "updateDeps";
          file = ./scripts/bundle.sh;
          buildInputs = [ pkgs.bundler pkgs.bundix ];
        }
        {
          name = "releaseToGithub";
          file = ./scripts/release_to_github.sh;
          buildInputs = [ pkgs.gh pkgs.ruby ];
        }
        {
          name = "releaseToRubygems";
          file = ./scripts/release_to_rubygems.sh;
          buildInputs = [ pkgs.ruby ];
        }
      ];

      wrappedScripts = (pkgs.callPackage 
        ./nix/scripts_wrapper
        { scripts = scripts; }
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
        packages = {
          default = devShells.default;
        } // wrappedScripts;
      }
    );
}
