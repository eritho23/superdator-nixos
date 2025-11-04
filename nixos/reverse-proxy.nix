{
  inputs,
  ...
}:
{
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
          # CSP is managed fully by SvelteKit.
                	Strict-Transport-Security "max-age=31536000; includeSubDomains"
                	X-Frame-Options "SAMEORIGIN"
                	X-Content-Type-Options "nosniff"
                	Referrer-Policy "no-referrer"
                	Permissions-Policy "geolocation=(), camera=(), microphone=()"
                }

                @fonts {
                	path *.woff2 *.woff *.ttf *.otf
                }
                header @fonts Cache-Control "public, max-age=31536000, immutable"
        '';
      };
      "aula.spetsen.net" = {
        extraConfig = ''
          header {
            Content-Security-Policy "default-src 'self'; img-src 'self' *.googleusercontent.com;"
          }
          reverse_proxy 127.0.0.1:4041
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
          reverse_proxy 127.0.0.1:9999
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
      "echoloungeuf.spetsen.net" = {
        extraConfig = ''
          root * ${inputs.echoloungeuf}/Reklamhemsida
          file_server

          header {
            Content-Security-Policy "default-src 'self'; style-src fonts.googleapis.com 'self'; font-src fonts.gstatic.com 'self'; script-src 'sha256-/4yvUaFYEK/vXBoauvrRnktmm07bdqdp9GUxARvsXOQ=';"
          	Last-Modified "${builtins.toString inputs.echoloungeuf.lastModified}"
          	Permissions-Policy "geolocation=(), camera=(), microphone=()"
          	Referrer-Policy "no-referrer"
          	Strict-Transport-Security "max-age=31536000; includeSubDomains"
          	X-Content-Type-Options "nosniff"
          	X-Frame-Options "SAMEORIGIN"
          }
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
      "justcount.app" = {
        extraConfig = ''
          root * ${inputs.justcountuf}/JustCount_Website
          file_server

          header {
          	Permissions-Policy "geolocation=(), camera=(), microphone=()"
          	Referrer-Policy "no-referrer"
          	Strict-Transport-Security "max-age=31536000; includeSubDomains"
          	X-Content-Type-Options "nosniff"
          	X-Frame-Options "SAMEORIGIN"
          }
        '';
      };
    };
  };
}
