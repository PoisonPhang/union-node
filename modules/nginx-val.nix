{ ... }:
{
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts =
      let
        domain = "testnet.val.poisonphang.com";

        redirect = subdomain: port: {
          "${subdomain}.${domain}" = {
            locations = {
              "/" = {
                proxyPass = "http://127.0.0.1:${toString port}";
                proxyWebsockets = true;
              };
            };
            enableACME = true;
            forceSSL = true;
            extraConfig = ''
              add_header Access-Control-Allow-Origin *;
              add_header Access-Control-Max-Age 3600;
              add_header Access-Control-Expose-Headers Content-Length;
            '';
          };
        };

        redirectGrpc = subdomain: port: {
          "${subdomain}.${domain}" = {
            enableACME = true;
            forceSSL = true;
            locations = {
              "/" = {
                extraConfig = ''
                  grpc_pass grpc://127.0.0.1:${toString port};
                  grpc_read_timeout      600;
                  grpc_send_timeout      600;
                  proxy_connect_timeout  600;
                  proxy_send_timeout     600;
                  proxy_read_timeout     600;
                  send_timeout           600;
                  proxy_request_buffering off;
                  proxy_buffering off;
                '';
              };
            };
          };
        };
      in
      redirect "rpc" 26657
      // redirect "api" 1317
      // redirectGrpc "grpc" 9090
      // redirect "grpc-web" 9091;
  };
}
