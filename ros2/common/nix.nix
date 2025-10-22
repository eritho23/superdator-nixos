{
  # enable nix-command, flakes
  nix.settings.extra-experimental-features = ["nix-command" "flakes"];

  # trusted users
  nix.settings.trusted-users = ["root" "@wheel"];

  # binary caches
  nix.settings.substituters = [
    "https://cache.nixos.org"
    "https://ros.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo="
  ];
}
