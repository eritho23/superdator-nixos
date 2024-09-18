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
      oidcIssuerPrivateKeyFile = config.sops.secrets."authelia/oidcIssuerPrivateKey".path;
      oidcHmacSecretFile = config.sops.secrets."authelia/oidcHmacSecret".path;
    };
    settings = {
      theme = "auto";
      default_redirection_url = "https://spetsen.net";

      server = {
        host = "127.0.0.1";
        port = 9091;
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

      session = {
        name = "authelia_session";
        expiration = "12h";
        inactivity = "45m";
        remember_me_duration = "1M";
        domain = "spetsen.net";
        redis.host = "/run/redis-authelia-main/redis.sock";
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
