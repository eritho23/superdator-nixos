{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  packages = with pkgs; [helix nil bat alejandra git];
}
