{pkgs, ...}: {
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    ensureDatabases = ["spetsctf"];
    ensureUsers."spetsctf" = {
      ensureDBOwnership = true;
      name = "spetsctf";
      ensureClauses.login = true;
    };
  };
}
