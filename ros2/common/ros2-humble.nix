{
  pkgs,
  lib,
  ...
}: let
  rosEnv = with pkgs.rosPackages.humble;
    buildEnv {
      name = "ros2-humble-env";
      paths = [
        desktop
      ];
    };
in {
  environment.systemPackages = with pkgs; [
    rosEnv
  ];

  # auto source ROS2 setup.bash
  programs.bash.interactiveShellInit = ''
    source ${rosEnv}/setup.bash
    export ROS_DOMAIN_ID=0
  '';
}
