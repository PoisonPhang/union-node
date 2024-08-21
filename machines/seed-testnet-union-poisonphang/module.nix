{ inputs, ... }:
{
  imports = [
    inputs.union.nixosModules.unionvisor
    inputs.sops-nix.nixosModules.sops
    ./configuration.nix
    ../../modules/datadog.nix
    ../../modules/environment.nix
    ../../modules/auth.nix
    ../../modules/nix.nix
    ../../modules/sops.nix
    ../../modules/nginx-seed.nix
    ../../modules/unionvisor-seed.nix
    {
      _module.args = {
        checks = {
          # Datadog does not handle Hetzner: https://github.com/DataDog/datadog-agent/issues/20369
          # Hence we need this workaround.
          ntp = {
            init_config = { };
            instances = [
              {
                hosts = [
                  "0.datadog.pool.ntp.org"
                  "1.datadog.pool.ntp.org"
                  "2.datadog.pool.ntp.org"
                  "3.datadog.pool.ntp.org"
                ];
              }
            ];
          };

          journald = {
            logs = [
              {
                type = "journald";
                container_mode = true;
              }
            ];
          };
        };

        security.acme = {
          acceptTerms = true;
          defaults.email = "connor@union.build";
        };

        networking.firewall.allowedTCPPorts = [ 80 443 26656 26657 10516 10518 ];
      };
    }
  ];
}
