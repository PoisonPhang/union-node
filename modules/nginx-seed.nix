{ pkgs, ... }:
{
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts =
      let
        domain = "testnet.seed.poisonphang.com";

        explorer = pkgs.mkYarnPackage {
          src = pkgs.fetchFromGitHub {
            owner = "hussein-aitlahcen";
            repo = "explorer";
            rev = "b4c23b94fe3245dddf0185e54b39dbb97117efa6";
            hash = "sha256-9S4XS6f7CliujM4AKq/AkII9wxI/ANsGrHd5GqXTUxE=";
          };
          configurePhase = ''
            cp -r $node_modules node_modules
            chmod +w node_modules
            substituteInPlace src/chains/testnet/union.json \
              --replace 0xc0dejug.uno ${domain}

          '';
          buildPhase = ''
            export HOME=$(mktemp -d)
            yarn --ignore-engine --offline build
          '';
          installPhase = ''
            mkdir -p $out
            mv dist/* $out/
          '';
          distPhase = "true";
        };

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
      // redirect "grpc-web" 9091
      // {
        "${domain}" = {
          enableACME = true;
          forceSSL = true;
          default = true;
          root = "${explorer}";
          locations."/" = {
            extraConfig = ''
              try_files $uri /index.html;
            '';
          };
        };
      };
  };
}
