{pkgs, ...}: {
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    ensureDatabases = ["spetsctf"];
    ensureUsers = [
      {
        name = "spetsctf";
        ensureClauses.login = true;
        ensureDBOwnership = true;
      }
    ];
  };
}
