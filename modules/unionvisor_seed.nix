{ inputs, config, ... }:
{
  services.unionvisor = {
    enable = true;
    moniker = "poisonphang-seed";
    network = "union-testnet-7";
    bundle = inputs.union.packages."x86_64-linux".bundle-testnet-7;
    node-key-json = config.sops.secrets.seed_node_key.path;
    priv-validator-key-json = config.sops.secrets.seed_priv_validator_key.path;
    app-toml = ../node_config/testnet_seed/app.toml;
    client-toml = ../node_config/testnet_seed/client.toml;
    config-toml = ../node_config/testnet_seed/config.toml;
  };
}
