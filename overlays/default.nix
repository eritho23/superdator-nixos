{inputs, ...}: {
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };

  ros2-humble = inputs.nix-ros-overlay.overlays.default;
}
