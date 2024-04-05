{ inputs, config, ... }:
{
  services.unionvisor = {
    enable = true;
    moniker = "poisonphang-val";
    network = "union-testnet-7";
    bundle = inputs.union.packages."x86_64-linux".bundle-testnet-7;
    node-key-json = config.sops.secrets.val_node_key.path;
    priv-validator-key-json = config.sops.secrets.val_priv_validator_key.path;
    app-toml = ../node_config/testnet_val/app.toml;
    client-toml = ../node_config/testnet_val/client.toml;
    config-toml = ../node_config/testnet_val/config.toml;
  };
}
