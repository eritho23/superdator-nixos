{config, ...}: {
  services.caddy = {
    enable = true;
    email = "eric.thorburn@hitachigymnasiet.se";
    virtualHosts = {
      "spetsen.net" = {
        extraConfig = ''
          respond "Should be a spets landing page"
        '';
      };
      "jupyter.spetsen.net" = {
        extraConfig = ''
	  forward_auth 127.0.0.1:9091 {
            uri /api/authz/forward-auth
	    copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
	  }
          reverse_proxy 127.0.0.1:8000
        '';
      };
      "auth.spetsen.net" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:9091
        '';
      };
    };
  };
}
