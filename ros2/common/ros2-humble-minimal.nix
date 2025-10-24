{
  pkgs,
  lib,
  ...
}: let
  rosEnv = with pkgs.rosPackages.humble;
    buildEnv {
      name = "ros2-humble-env";
      paths = [
        ros-core
      ];
    };
in {
  environment.systemPackages = with pkgs; [
    rosEnv
  ];

  # auto source ROS2 setup.bash
  programs.bash.interactiveShellInit = ''
    export ROS_DOMAIN_ID=0
  '';
}
