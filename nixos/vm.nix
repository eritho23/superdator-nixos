{...}: let
  # These options are used by the host when running a virtualized (VM) build of
  # the system.
  virtualisation = {
    memorySize = 8192;
    cores = 8;
    qemu.options = [
      "-accel kvm"
      "-audio pa"
    ];
  };
in {
  virtualisation.vmVariant = {
    inherit virtualisation;
  };
  virtualisation.vmVariantWithBootLoader = {
    inherit virtualisation;
  };

  imports = [
    # Act as a host for MicroVMs.
    # microvm.nixosModules.host
  ];
}
