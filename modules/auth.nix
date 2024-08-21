{ ... }:
{
  services.fail2ban.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID5vBi9m4kCzRnoUFj5xMsLz4N/Np7x0Wq3h9dQv2nEt'' #connor
  ];
}
