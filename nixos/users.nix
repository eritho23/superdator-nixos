{config, pkgs, ...}: 
#let
# For ComfyUI
 #erresPython = pkgs.python3.withPackages (po:
    #with po; [
      #torch-bin
      #torchsde
      #torchvision-bin
      #torchaudio-bin
      #einops
      #transformers
      #tokenizers
      #sentencepiece
      #safetensors
      #aiohttp
      #pyyaml
      #pillow
      #scipy
      #tqdm
      #psutil
    #]);
#in
{
  users.users."erre" = {
    isNormalUser = true;
    uid = 1001;
    initialPassword = "1234";
    extraGroups = ["wheel" "ssh-access"];
    packages = with pkgs; [chezmoi];
    openssh.authorizedKeys.keys = [];
  };

  users.users."malte" = {
    isNormalUser = true;
    uid = 1002;
    initialPassword = "4567";
    extraGroups = ["wheel" "ssh-access"];
    # packages = with pkgs; [];
  };

  users.users."nojus" = {
    isNormalUser = true;
    uid = 1003;
    initialPassword = "abcd";
    extraGroups = ["wheel" "ssh-access"];
    # packages = with pkgs; [];
  };

  #  users.users."jakobi" = {
  #    isNormalUser = true;
  #    uid = 1004;
  #    initialPassword = "efgh";
  #    # extraGroups = ["wheel"];
  #    # packages = with pkgs; [];
  #  };

  #  users.users."kjell-urban" = {
  #    isNormalUser = true;
  #    uid = 1005;
  #    initialPassword = "racecar";
  #    # extraGroups = ["wheel"];
  #    # packages = with pkgs; [];
  #  };

  users.users."ai-agent" = {
    isNormalUser = true;
    uid = 1100;
    extraGroups = ["video"];
  };

  users.users."flink" = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets.flinks_password.path;
    uid = 1006;
    extraGroups = ["ssh-access"];
  };

  users.groups."ssh-access" = {};
}
