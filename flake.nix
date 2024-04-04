{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs"; 
    };

    union.url = "github:unionlabs/union/release-v0.20.0";
  };
  outputs = {nixpkgs, union, sops-nix, ... }:
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
              system.stateVersion = "23.11";

              networking.firewall.allowedTCPPorts = [ 80 443 26656 26657 ];

              services.unionvisor = {
                enable = true;
                moniker = "poisonphang-val";
                network = "union-testnet-7";
                bundle = union.packages.${system}.bundle-testnet-7;
              };

              security.acme = {
                acceptTerms = true;
                defaults.email = "connor@union.build";
              };
            }
          ];
        };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };
}
