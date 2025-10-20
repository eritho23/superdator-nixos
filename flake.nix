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
    microvm.url = "github:microvm-nix/microvm.nix";
    microvm.inputs.nixpkgs.follows = "nixpkgs-unstable";
    # Disko
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    # Lanzaboote
    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.2";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    ### FLAKE INPUTS FOR DEPLOYMENTS BELOW ###
    spetsctf = {
      url = "github:fdABB-Gym-Samuel/SpetsCTF/d45aa5f9d5c2b95238c208d45a40cf4a934c100c";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    spetsctf-services = {
      url = "git+ssh://git@github.com/fdABB-Gym-Samuel/SpetsCTF-services?rev=08e89152156dcc24fcc111938283ee813f9cd796";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.microvm.follows = "microvm";
    };
    aulabokning = {
      url = "git+ssh://git@github.com/eritho23/aulabokning?rev=716c1d93b55a7a1aa530c2f3491b1038861facf5";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    echoloungeuf = {
      url = "git+ssh://git@github.com/Miraengel/GYARTE";
      flake = false;
    };
    ### END FLAKE INPUTS FOR DEPLOYMENTS ###
  };

  outputs = {
    self,
    nixpkgs,
    systems,
    disko,
    sops-nix,
    lanzaboote,
    treefmt-nix,
    microvm,
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
    nixosConfigurations =
      {
        # Configuration for the NixOS system
        superdator = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit (self) inputs outputs;};
          modules = [
            ./nixos/configuration.nix

            # add sops secrets
            sops-nix.nixosModules.sops
            microvm.nixosModules.host
          ];
        };
      }
      # ROS2 full env workstations
      // pkgs.lib.genAttrs ["dunning" "kruger"] (
        hostname:
          nixpkgs.lib.nixosSystem {
            specialArgs = {inherit (self) inputs outputs;};
            modules = [
              {nixpkgs.overlays = builtins.attrValues self.overlays;}
              sops-nix.nixosModules.sops
              disko.nixosModules.disko
              lanzaboote.nixosModules.lanzaboote

              {
                networking.hostName = hostname;
              }

              ./ros2/common
              (./ros2 + "/disko-${hostname}.nix")
              (./ros2 + "/hardware-configuration-${hostname}.nix")
              (./ros2 + "/bootloader-${hostname}.nix")
            ];
          }
      )
      # ROS2 minimal workstations
      // pkgs.lib.genAttrs ["splinter" "leonardo" "donatello"] (
        hostname:
          nixpkgs.lib.nixosSystem {
            specialArgs = {inherit (self) inputs outputs;};
            modules = [
              {nixpkgs.overlays = builtins.attrValues self.overlays;}
              sops-nix.nixosModules.sops
              disko.nixosModules.disko
              lanzaboote.nixosModules.lanzaboote
              {
                networking.hostName = hostname;
              }

              ./ros2/common/default-minimal.nix
              (./ros2 + "/disko-${hostname}.nix")
              (./ros2 + "/hardware-configuration-${hostname}.nix")
              (./ros2 + "/bootloader-${hostname}.nix")
            ];
          }
      );

    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [neovim nixd bat ripgrep alejandra git nixos-generators age sops frankenphp helix];
    };
  };
}
