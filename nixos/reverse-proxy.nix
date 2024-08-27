{config, ...}:
{
  services.caddy = {
    enable = true;
    email = "eric.thorburn@hitachigymnasiet.se";
    virtualHosts = {
      "spetsen.net"= {
        extraConfig = ''
          respond "Hello, World!"
        '';
      };
      "jupyter.spetsen.net" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8000
	'';
      };
    };
  };
}
