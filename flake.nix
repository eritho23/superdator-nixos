{
  description = "NixOS flake for the super computer";

  inputs = {
    # Input stable nixpkgs for use in the OS
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    # Unstable packages for things like tailscale
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # SOPS for secret management.
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    ### FLAKE INPUTS FOR DEPLOYMENTS BELOW ###
    spetsctf = {
      url = "github:fdABB-Gym-Samuel/SpetsCTF/502e90cd6fe2770ed59cd19a49941e56f2af886d";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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
      packages = with pkgs; [neovim nil bat ripgrep alejandra git nixos-generators age sops];
    };
  };
}
