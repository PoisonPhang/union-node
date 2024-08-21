{ pkgs, checks, ... }:
{
  users.users.datadog.extraGroups = [ "systemd-journal" ];

  services.datadog-agent = {
    inherit checks;
    package = pkgs.datadog-agent.override { buildGoModule = pkgs.buildGo121Module; };
    enable = true;
    apiKeyFile = "/etc/datadog-agent/datadog_api.key";
    enableLiveProcessCollection = true;
    enableTraceAgent = true;
    site = "datadoghq.com";
    extraConfig = { logs_enabled = true; };
    extraIntegrations = {
      http_check = pythonPackages: [ pythonPackages.hatchling ];
      journald = pythonPackages: [ pythonPackages.hatchling ];
      openmetrics = _: [ ];
    };
  };
}
