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
      "ctf.spetsen.net" = {
        extraConfig = ''
                 reverse_proxy 127.0.0.1:3333
          header {
                   Content-Security-Policy "connect-src 'none'; default-src 'self'; font-src 'none'; manifest-src 'none'; object-src 'none'; worker-src 'none';"
            Strict-Transport-Security "max-age=31536000; includeSubDomains"
            X-Frame-Options "SAMEORIGIN"
            X-Content-Type-Options "nosniff"
            Referrer-Policy "no-referrer"
            Permissions-Policy "geolocation=(), camera=(), microphone=()"
          }
        '';
      };
      "jupyter.superdator.spetsen.net" = {
        extraConfig = ''
                 forward_auth 127.0.0.1:9091 {
                   uri /api/authz/forward-auth
                   copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
                 }
          reverse_proxy 127.0.0.1:8000
        '';
      };
      "chat.superdator.spetsen.net" = {
        extraConfig = ''
          forward_auth 127.0.0.1:9091 {
                    uri /api/authz/forward-auth
                    copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
          }
                 # reverse_proxy 127.0.0.1:9999
          respond "Disabled"

        '';
      };
      "auth.superdator.spetsen.net" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:9091
        '';
      };
      "justcount-pb.superdator.spetsen.net" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8092
        '';
      };
      "boka.spetsen.net" = {
        extraConfig = ''
                  @websockets {
                    header Connection *Upgrade*
                    header Upgrade    websocket
                  }
          reverse_proxy @websockets 127.0.0.1:5001
          reverse_proxy 127.0.0.1:5000
        '';
      };
    };
  };
}
