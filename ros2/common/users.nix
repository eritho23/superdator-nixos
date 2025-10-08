{
  security.doas.enable = true;

  users.mutableUsers = false;

  users.users."erre" = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    hashedPassword = "$y$j9T$BLLCIfqdRgkRyrQ4TARJJ1$pwnDWxkUUxJgfYukgUt0IjuG1cf676AsB1pwKDCfse7";
  };
}
