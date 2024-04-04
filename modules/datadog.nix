{ ... }:
{
  users.users.datadog.extraGroups = [ "systemd-journal" ];

  services.datadog-agent = {
    enable = true;
    apiKeyFile = "/etc/datadog-agent/datadog_api.key";
    enableLiveProcessCollection = true;
    enableTraceAgent = true;
    site = "datadoghq.com";
    extraIntegrations = { openmetrics = _: [ ]; };
    extraConfig = { logs_enabled = true; };
    checks = {
      journald = { logs = [{ type = "journald"; }]; };
    };
  };
}
