{
  description = "NixOS flake for the super computer";

  inputs = {
    # Input stable nixpkgs for use in the OS
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11-small";
  };

  outputs = { self, nixpkgs, ...} @inputs: 
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
    inherit (self) outputs;
  in
  {
    nixosConfigurations = {
      superdator = pkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [ ./nixos/superdator/configuration.nix ];
      };
    };
  };
}
