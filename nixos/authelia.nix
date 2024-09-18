{
  config,
  pkgs,
  ...
}: {
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
      default_redirection_url = "https://spetsen.net";

      server = {
        address = "tcp://127.0.0.1:9091/";
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
        domain = "spetsen.net";
        redis.host = "/run/redis-authelia-main/redis.sock";
      };

      access_control = {
        default_policy = "deny";
        rules = [
          {
            domain = ["auth.spetsen.net"];
            policy = "bypass";
          }
          {
            domain = ["*.spetsen.net"];
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
