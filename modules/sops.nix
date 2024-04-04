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
    # priv_validator_key = {
    #   restartUnits = [ "unionvisor.service" ];
    #   format = "binary";
    #   sopsFile = ./secrets/wakey-rpc/priv_validator_key.json;
    #   path = "/var/lib/unionvisor/home/config/priv_validator_key.json";
    # };
  };
};
}
