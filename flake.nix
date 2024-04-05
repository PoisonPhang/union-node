{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs"; 
    };

    union.url = "github:unionlabs/union/release-v0.20.0";
  };
  outputs = { self, nixpkgs, union, sops-nix }@inputs:
    {
      nixosConfigurations.poisonphang-val =
        let
          system = "x86_64-linux";
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            union.nixosModules.unionvisor
            sops-nix.nixosModules.sops
            "${nixpkgs}/nixos/modules/virtualisation/openstack-config.nix"
            {
              config = {
                system.stateVersion = "23.11";

                security.acme = {
                  acceptTerms = true;
                  defaults.email = "connor@union.build";
                };

                networking.firewall.allowedTCPPorts = [ 80 443 26656 26657 ];

                _module.args = {
                  inherit inputs;
                };
              };
            }
            ./modules/datadog.nix
            ./modules/environment.nix
            ./modules/nginx-val.nix
            ./modules/nix.nix
            ./modules/sops.nix
            ./modules/unionvisor_val.nix
          ];
        };
      nixosConfigurations.poisonphang-seed =
        let
          system = "x86_64-linux";
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            union.nixosModules.unionvisor
            sops-nix.nixosModules.sops
            "${nixpkgs}/nixos/modules/virtualisation/openstack-config.nix"
            {
              config = {
                system.stateVersion = "23.11";
                security.acme = {
                  acceptTerms = true;
                  defaults.email = "connor@union.build";
                };

                networking.firewall.allowedTCPPorts = [ 80 443 26656 26657 ];

                _module.args = {
                  inherit inputs;
                };
              };
            }
            ./modules/datadog.nix
            ./modules/environment.nix
            ./modules/nginx-seed.nix
            ./modules/nix.nix
            ./modules/sops.nix
            ./modules/unionvisor_seed.nix
          ];
        };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };
}
