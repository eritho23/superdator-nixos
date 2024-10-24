{
  description = "NixOS flake for the super computer";

  inputs = {
    # Input unstable Nixpkgs for use in the OS.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # SOPS for secret management.
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    sops-nix,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) (map lib.getName (with pkgs; [
        linuxPackages_6_10.nvidia_x11
        cudaPackages.cuda_cudart
        cudaPackages.libcublas
        cudaPackages.cuda_cccl
        cudaPackages.cuda_nvcc
        cudaPackages.cudatoolkit
        cudaPackages.cuda_cuobjdump
        cudaPackages.cuda_gdb
        cudaPackages.cuda_nvdisasm
        cudaPackages.cuda_nvprune
        cudaPackages.cuda_cupti
        cudaPackages.cuda_cuxxfilt
        cudaPackages.cuda_nvml_dev
        cudaPackages.cuda_nvrtc
        cudaPackages.cuda_nvtx
        cudaPackages.cuda_profiler_api
        cudaPackages.cuda_sanitizer_api
        cudaPackages.libcufft
        cudaPackages.libcurand
        cudaPackages.libcusolver
        cudaPackages.libnvjitlink
        cudaPackages.libcusparse
        cudaPackages.libnpp
        cudaPackages.cudnn
        python311Packages.triton
        python311Packages.torch
      ]));
    };
    inherit (pkgs) lib outputs;
  in {
    nixosConfigurations = {
      superdator = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };
        modules = [
          # Register the Nixpkgs unfree predicate at module-level.
          { nixpkgs.config.allowUnfreePredicate = pkgs.config.allowUnfreePredicate; }
          ./nixos/configuration.nix
          # Enable SOPS secrets.
          sops-nix.nixosModules.sops
        ];
      };
    };

    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [neovim nil bat ripgrep alejandra git nixos-generators age sops];
    };
  };
}

