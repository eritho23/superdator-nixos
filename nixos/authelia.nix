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
    environmentVariables = {
      AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE = config.sops.secrets."authelia/ldapPassword".path;
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
        # file = {
        # path = "/var/lib/authelia-main/users_database.yml";
        # };
        ldap = {
          address = "ldaps://10.21.1.2";
          implementation = "activedirectory";
          base_dn = "OU=AbbIndGym,DC=abbindustrigymnasium,DC=local";
          user = "CN=23eritho,OU=TES V230S,OU=Västerås,OU=Elever,OU=ABBIndGym,DC=abbindustrigymnasium,DC=local";
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
        redis.host = "/run/redis-authelia-main/redis.sock";
        cookies = [
          {
            domain = "spetsen.net";
            authelia_url = "https://auth.spetsen.net";
            default_redirection_url = "https://spetsen.net";
          }
        ];
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
