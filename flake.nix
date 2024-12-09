{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05-small";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    union.url = "github:unionlabs/union/main";
    unionvisor.url = "github:unionlabs/union/main";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    flake-parts.url = "github:hercules-ci/flake-parts";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{ self
    , nixpkgs
    , nixpkgs-unstable
    , union
    , sops-nix
    , flake-utils
    , flake-parts
    , treefmt-nix
    , ...
    }:
    let
      commonDependencies = systemPkgs: with systemPkgs; [
        just
        direnv
        grpcurl
      ] ++ (with (import nixpkgs-unstable { inherit (systemPkgs) system; }); [
        nodejs
        nodePackages.pnpm
      ]);
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = [
        inputs.treefmt-nix.flakeModule
      ];
      flake = {
        nixosConfigurations =
          let
            mkSystem = { system, module, overlays ? [ ], ... }:
              let
                systemPkgs = import nixpkgs {
                  inherit system overlays;
                  config = {
                    allowUnfree = true;
                    extra-substituters = [ "https://union.cachix.org" "https://cache.garnix.io" ];
                    extra-trusted-public-keys =
                      [ "union.cachix.org-1:TV9o8jexzNVbM1VNBOq9fu8NK+hL6ZhOyOh0quATy+M=" "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
                  };
                };
              in
              nixpkgs.lib.nixosSystem {
                inherit system;
                specialArgs = {
                  inherit inputs;
                };
                modules = [
                  module
                  ({ pkgs, ... }: {
                    environment.systemPackages = commonDependencies pkgs;
                  })
                ];
                pkgs = systemPkgs;
              };
          in
          {
            poisonphang-val = mkSystem {
              system = "x86_64-linux";
              module = ./machines/val-testnet-union-poisonphang/module.nix;
            };
            poisonphang-seed = mkSystem {
              system = "x86_64-linux";
              module = ./machines/seed-testnet-union-poisonphang/module.nix;
            };
          };
      };
      perSystem = { self', system, lib, config, pkgs, ... }:
        {
          _module.args.pkgs = import self.inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          treefmt.config = {
            projectRootFile = "flake.nix";
            programs = {
              nixpkgs-fmt.enable = true;
            };
          };
        };
    };
  nixConfig = {
    extra-substituters = [ "https://union.cachix.org" "https://cache.garnix.io" ];
    extra-trusted-public-keys =
      [ "union.cachix.org-1:TV9o8jexzNVbM1VNBOq9fu8NK+hL6ZhOyOh0quATy+M=" "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
    accept-flake-config = true;
  };
}
