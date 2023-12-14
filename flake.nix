{
  description = "dryer-services gem dev environment";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
    nix-filter.url = "github:numtide/nix-filter";
  };

  outputs = { self, nixpkgs, flake-utils, nix-filter }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      overlays = [
        (final: prev: {
          ruby = final.ruby_3_1;
        })
      ];
      pkgs = import nixpkgs { inherit system overlays; };

    in with pkgs;
      rec {
        devShells = rec {
          default = run;
          run = ( callPackage 
            ./nix/ruby_gem_dev_shell
            { 
              project_root = ./.;
              gemspec = ./dryer_services.gemspec;
            }
          );
        };
        packages = {
          default = devShells.default;
        };
      }
    );
}
