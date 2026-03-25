{pkgs, ...}: {
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    ensureDatabases = ["spetsctf" "classy"];
    ensureUsers = [
      {
        name = "spetsctf";
        ensureClauses.login = true;
        ensureDBOwnership = true;
      }
      {
        name = "classy";
        ensureClauses.login = true;
        ensureDBOwnership = true;
      }
    ];
  };
}
