{ ... }:

{
  # nix.package = pkgs.nixVersions.latest;

  # Enable daily automatic garbage collection of the Nix store.
  nix.gc = {
    automatic = true;
    dates = "03:15";
    options = "--delete-older-than 7d";
  };

  # Enable flakes and the new nix command line on the server.
  nix.settings.extra-experimental-features = ["nix-command" "flakes"];

  # Connection timeout against Nix binary cache in seconds.
  # https://nix.dev/manual/nix/2.24/command-ref/conf-file.html#conf-connect-timeout
  nix.settings.connect-timeout = 5;
}

