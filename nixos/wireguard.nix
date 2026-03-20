{
  pkgs,
  lib,
  ...
}: {
  networking.nat.internalInterfaces = lib.mkAfter ["wg0"];

  system.activationScripts.wireguard-key = lib.stringAfter ["users"] ''
    install -d -m 0700 /var/lib/wireguard

    if [ ! -s /var/lib/wireguard/private.key ]; then
      umask 077
      ${pkgs.wireguard-tools}/bin/wg genkey > /var/lib/wireguard/private.key
    fi

    ${pkgs.wireguard-tools}/bin/wg pubkey < /var/lib/wireguard/private.key > /var/lib/wireguard/public.key
    chmod 0600 /var/lib/wireguard/private.key
    chmod 0644 /var/lib/wireguard/public.key
  '';

  networking.wireguard.interfaces.wg0 = {
    ips = ["10.20.0.1/24"];
    listenPort = 51820;
    privateKeyFile = "/var/lib/wireguard/private.key";

    peers = [
      # Gustav 240s 
      {
        publicKey = "flSCrbUHhZNM7mON7vKA7FB0bvPpZmmgO/wz8ZnB6Hs=";
        allowedIPs = ["10.20.0.10/32"];
        persistentKeepalive = 25;
      }
    ];
  };
}
