{
  # enable nix-command, flakes
  nix.settings.extra-experimental-features = ["nix-command" "flakes"];

  # trusted users
  nix.settings.trusted-users = ["root" "@wheel"];
}
