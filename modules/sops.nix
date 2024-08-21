{ ... }:
{
  sops = {
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    secrets = {
      datadog_api_key = {
        restartUnits = [ "datadog-agent.service" ];
        path = "/etc/datadog-agent/datadog_api.key";
        sopsFile = ../secrets/datadog.yaml;
        mode = "0440";
        owner = "datadog";
      };
      seed_priv_validator_key = {
        restartUnits = [ "unionvisor.service" ];
        format = "binary";
        sopsFile = ../secrets/seed_priv_validator_key.json;
      };
      val_priv_validator_key = {
        restartUnits = [ "unionvisor.service" ];
        format = "binary";
        sopsFile = ../secrets/val_priv_validator_key.json;
      };
      seed_node_key = {
        restartUnits = [ "unionvisor.service" ];
        format = "binary";
        sopsFile = ../secrets/seed_node_key.json;
      };
      val_node_key = {
        restartUnits = [ "unionvisor.service" ];
        format = "binary";
        sopsFile = ../secrets/val_node_key.json;
      };
    };
  };
}
