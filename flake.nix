{
  description = "NixOS flake for the super computer";

  inputs = {
    # Input unstable nixpkgs for use in the OS
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Sops for secret management
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    sops-nix,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
    inherit (self) outputs;
  in {
    # Add overlays

    nixosConfigurations = {
      # Configuration for the NixOS system
      superdator = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
	  ./nixos/configuration.nix

	  # add sops secrets
	  sops-nix.nixosModules.sops
	];
      };
    };

    devShells."${system}".default = pkgs.mkShell {
      packages = with pkgs; [neovim nil bat ripgrep alejandra git nixos-generators age sops];
    };
  };
}
