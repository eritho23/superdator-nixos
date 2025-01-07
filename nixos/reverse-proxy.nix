{...}: {
  services.caddy = {
    enable = true;
    email = "eric.thorburn@hitachigymnasiet.se";
    virtualHosts = {
      "superdator.spetsen.net" = {
        extraConfig = ''
          respond "Should be a fancy superdator landing page"
        '';
      };
      "jupyter.superdator.spetsen.net" = {
        extraConfig = ''
          forward_auth 127.0.0.1:9091 {
            uri /api/authz/forward-auth
            copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
          }
          respond "Disabled"
        '';
      };
      "chat.superdator.spetsen.net" = {
        extraConfig = ''
                 forward_auth 127.0.0.1:9091 {
            uri /api/authz/forward-auth
            copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
                 }
          reverse_proxy 127.0.0.1:9999

        '';
      };
      "auth.superdator.spetsen.net" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:9091
        '';
      };
      "parkpappa-pb.superdator.spetsen.net" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8090
        '';
      };
      "zmartrest-pb.superdator.spetsen.net" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8090
        '';
      };
    };
  };
}
