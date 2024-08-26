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

        explorer = pkgs.stdenv.mkDerivation (finalAttrs: {
          name = "pingpub-explorer";
          src = pkgs.fetchFromGitHub {
          owner = "unionlabs";
          repo = "explorer";
          rev = "749cfb4184007f8e47aa2bf949cd192daf3c8b5f";
          hash = "sha256-FLV20URgeypf/mVYYTV+SFBRt0aEq9qeY8KwD0qWNO4=";
        };

          offlineCache = pkgs.fetchYarnDeps {
            yarnLock = "${finalAttrs.src}/yarn.lock";
            hash = "sha256-Hrru2qmsYUdrrWQ08F86BpQG84iCrNbVXomVTecvru8=";
          };

          nativeBuildInputs = with pkgs; [
            fixup-yarn-lock
            nodejs
            tree
            nodePackages.npm
            nodePackages.yarn
          ];

          configurePhase = ''
            runHook preConfigure

            export HOME=$(mktemp -d)

            yarn config --offline set yarn-offline-mirror ${finalAttrs.offlineCache}
            fixup-yarn-lock yarn.lock
            yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
            export PATH="$PATH:node_modules/vite/bin"

            patchShebangs node_modules/

            runHook postConfigure
          '';

          buildPhase = ''
            # yarn --ignore-engines --offline && yarn --offline build
            ./node_modules/vite/bin/vite.js build
          '';

          installPhase = ''
            mkdir -p $out
            mv dist/* $out/
          '';
        });

        # explorer = pkgs.mkYarnPackage {
          # src = pkgs.fetchFromGitHub {
          #   owner = "unionlabs";
          #   repo = "explorer";
          #   rev = "51a74de55bdeb54f0c2778794c8db41695ac3c4a";
          #   hash = "sha256-CUK6f1XFOyb6FaFQF2REbLmYVya2o3Pk0dfDSJv06v8=";
          # };
        #   configurePhase = ''
        #     cp -r $node_modules node_modules
        #     chmod +w node_modules
        #   '';
        #   buildPhase = ''
        #     export HOME=$(mktemp -d)
        #     yarn --ignore-engine --offline && yarn --offline build
        #   '';
        #   installPhase = ''
        #     mkdir -p $out
        #     mv dist/* $out/
        #   '';
        #   distPhase = "true";
        # };

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
