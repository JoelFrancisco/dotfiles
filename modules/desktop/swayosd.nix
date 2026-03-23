{ ... }:

let
  assetsPath = ../../assets;
in
{
  flake.nixosModules.swayosd = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.swayosd ];
  };

  flake.homeManagerModules.swayosd = { lib, ... }: {
    home.activation.initSwayosdConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      [ -d "$HOME/.config/swayosd" ] || mkdir -p "$HOME/.config/swayosd"
      [ -f "$HOME/.config/swayosd/style.css" ] || install -Dm644 "${assetsPath}/config/swayosd/style.css" "$HOME/.config/swayosd/style.css" 2>/dev/null || true
    '';
  };
}
