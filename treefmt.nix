{...}: {
  # Used to find the project root
  projectRootFile = "flake.nix";
  programs.alejandra.enable = true;
  programs.dos2unix.enable = true;
}
