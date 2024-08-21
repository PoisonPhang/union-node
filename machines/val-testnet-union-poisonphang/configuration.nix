{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect

  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "val-testnet-union-poisonphang";
  networking.domain = "";
  services.openssh.enable = true;
  system.stateVersion = "23.11";
}
