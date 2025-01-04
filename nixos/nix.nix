{
  # Enable daily automatic garbage collection of the nix store
  nix.gc = {
    automatic = true;
    dates = "03:15";
    # Only delete things older than 7 days
    options = "--delete-older-than 7d";
  };

  # Enable flakes and the new nix command line on the server
  nix.settings.extra-experimental-features = ["nix-command" "flakes"];

  # Add connect timeout to nix
  nix.settings.connect-timeout = 5;
}
