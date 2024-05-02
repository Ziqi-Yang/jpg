{
  description = "A Nix-flake-based development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
    forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    });
  in {
    # FIXME (mainly because the symbol link problem mentioned in jpg.sh)
    packages = forAllSystems ({ pkgs }: {
      default  = pkgs.callPackage ./nix/package.nix {};
    });
    
    devShells = forAllSystems ({ pkgs }: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          just
        ];
      };
    });
  };
}
