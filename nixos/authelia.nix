{config, ...}: {
  services.authelia.instances.main = {
    enable = true;
    secrets = {
      jwtSecretFile = config.sops.secrets."authelia/jwtSecret".path;
      storageEncryptionKeyFile = config.sops.secrets."authelia/storageEncryptionKey".path;
      sessionSecretFile = config.sops.secrets."authelia/sessionSecret".path;
      # oidcIssuerPrivateKeyFile = config.sops.secrets."authelia/oidcIssuerPrivateKey".path;
      # oidcHmacSecretFile = config.sops.secrets."authelia/oidcHmacSecret".path;
    };
    settings = {
      theme = "auto";

      server = {
        address = "tcp://127.0.0.1:9091/";
        endpoints = {
          authz = {
            forward-auth = {
              implementation = "ForwardAuth";
            };
          };
        };
      };

      log = {
        level = "debug";
        format = "text";
      };

      authentication_backend = {
        file = {
          path = "/var/lib/authelia-main/users_database.yml";
        };
      };

      storage = {
        local = {
          path = "/var/lib/authelia-main/db.sqlite3";
        };
      };

      # identity_providers = {
      #   oidc = {
      #     clients = [
      #       {
      #         client_id = "abcd";
      #         client_name = "Open WebUI";
      #         client_secret = "{{ env \"OPEN_WEBUI_CLIENT_SECRET\" }}";
      #         public = false;
      #         authorization_policy = "one_factor";
      #         require_pkce = false;
      #         pkce_challenge_method = "";
      #         redirect_uris = ["https://aaa.se"];
      #         scopes = ["openid" "profile" "groups" "email"];
      #         response_types = ["code"];
      #         grant_types = ["authorization_code"];
      #         access_token_signed_response_alg = "none";
      #         userinfo_signed_response_alg = "none";
      #         token_endpoint_auth_method = "client_secret_basic";
      #       }
      #     ];
      #   };
      # };

      notifier = {
        disable_startup_check = false;
        filesystem = {
          filename = "/var/lib/authelia-main/notification.txt";
        };
      };

      session = {
        name = "authelia_session";
        expiration = "12h";
        inactivity = "45m";
        remember_me = "1M";
        redis.host = "/run/redis-authelia-main/redis.sock";
        cookies = [
          {
            domain = "spetsen.net";
            authelia_url = "https://auth.superdator.spetsen.net";
            default_redirection_url = "https://superdator.spetsen.net";
          }
        ];
      };

      access_control = {
        default_policy = "deny";
        rules = [
          {
            domain = ["auth.superdator.spetsen.net"];
            policy = "bypass";
          }
          {
            domain = ["*.superdator.spetsen.net"];
            policy = "one_factor";
          }
        ];
      };
    };
  };

  services.redis.servers.authelia-main = {
    enable = true;
    user = "authelia-main";
    port = 0;
    unixSocket = "/run/redis-authelia-main/redis.sock";
    unixSocketPerm = 600;
  };
}
