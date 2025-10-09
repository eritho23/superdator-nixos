{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = [
    (pkgs.stdenv.mkDerivation {
      pname = "unitree_sdk2";
      version = "2.0.2";

      src = pkgs.fetchFromGitHub {
        owner = "unitreerobotics";
        repo = "unitree_sdk2";
        rev = "2.0.2";
        hash = "sha256-a+O3jQDJFq/v0zhpGJVuwjgWAZWkIqiNfKt/L4IOSco=";
      };

      nativeBuildInputs = with pkgs; [cmake];
      buildInputs = with pkgs; [eigen];
    })
  ];
}
