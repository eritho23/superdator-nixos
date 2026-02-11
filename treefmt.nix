_: {
  projectRootFile = "flake.nix";

  programs = {
    alejandra.enable = true;
    dos2unix.enable = true;
    statix.enable = true;
    deadnix.enable = true;
  };
}
