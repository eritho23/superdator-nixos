{
  description = "NixOS flake for the super computer";

  inputs = {
    # Input stable nixpkgs for use in the OS
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    # Unstable packages for things like tailscale
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # SOPS for secret management.
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    # MicroVMs
    # microvm.url = "github:microvm-nix/microvm.nix";
    # microvm.inputs.nixpkgs.follows = "nixpkgs-unstable";

    ### FLAKE INPUTS FOR DEPLOYMENTS BELOW ###
    spetsctf = {
      url = "github:fdABB-Gym-Samuel/SpetsCTF/9be634e60ff420d969cfe4d91432fbc9d1b137a4";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    aulabokning = {
      url = "git+https://git@github.com/eritho23/aulabokning?rev=741e439f808b822bb3fff049c78d9028da6d9434";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    echoloungeuf = {
      url = "git+https://git@github.com/Miraengel/GYARTE";
      flake = false;
    };
    ### END FLAKE INPUTS FOR DEPLOYMENTS ###
  };

  outputs = {
    self,
    nixpkgs,
    systems,
    sops-nix,
    treefmt-nix,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
    eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});
    treefmtEval = eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
  in {
    # Add overlays
    overlays = import ./overlays {inherit inputs;};
    formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);
    nixosConfigurations = {
      # Configuration for the NixOS system
      superdator = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit (self) inputs outputs;};
        modules = [
          ./nixos/configuration.nix

          # add sops secrets
          sops-nix.nixosModules.sops
        ];
      };
    };

    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [neovim nixd bat ripgrep alejandra git nixos-generators age sops frankenphp helix];
    };
  };
}
