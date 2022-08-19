{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus";
    mc-config.url = "github:luochen1990/minecraft-mods/dev";
    mc-config.inputs.nixpkgs.follows = "nixpkgs";
    mc-config.inputs.flake-utils-plus.follows = "flake-utils-plus";
    mc-config.inputs.minecraft-nix.follows = "minecraft-nix";
    mc-config.inputs.minecraft-json.follows = "minecraft-json";
    minecraft-nix.url = "github:ninlives/minecraft.nix";
    minecraft-nix.inputs.nixpkgs.follows = "nixpkgs";
    minecraft-nix.inputs.flake-utils.follows = "flake-utils-plus/flake-utils";
    minecraft-nix.inputs.metadata.follows = "minecraft-json";
    minecraft-json.url = "github:ninlives/minecraft.json";
    minecraft-json.inputs.nixpkgs.follows = "nixpkgs";
    minecraft-json.inputs.flake-utils.follows = "flake-utils-plus/flake-utils";
  };
  outputs = inputs@{ self, nixpkgs, mc-config, flake-utils-plus, ... }:
    let utils = flake-utils-plus.lib;
    in utils.mkFlake {
      inherit self inputs;
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" ];
      outputsBuilder = channels:
        let
          pkgs = channels.nixpkgs;
          system = pkgs.stdenv.hostPlatform.system;
          inherit (pkgs) lib;
          contents = if builtins.pathExists ./config.lock.json then
            mc-config.lib.mkLaunchers pkgs {
              launcherConfig = lib.importJSON ./config.lock.json;
            }
          else
            { };
        in {
          inherit contents;
          packages = utils.flattenTree contents // {
            inherit (mc-config.packages.${system}) update;
          };
          checks = self.packages.${system};
          devShells.default =
            pkgs.mkShell { packages = with pkgs; [ fup-repl nixfmt fd ]; };
        };
    };
}
