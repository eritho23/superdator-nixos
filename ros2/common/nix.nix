{
  # enable nix-command, flakes
  nix.settings.extra-experimental-features = ["nix-command" "flakes"];

  # trusted users
  nix.settings.trusted-users = ["root" "@wheel"];

  substituters = [
    "https://cache.nixos.org"
  ];

  trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];
}
