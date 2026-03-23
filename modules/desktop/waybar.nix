{ ... }:

let
  assetsPath = ../../assets;
in
{
  flake.nixosModules.waybar = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.waybar ];
  };

  flake.homeManagerModules.waybar = { lib, ... }: {
    # Waybar config is managed as mutable user files to allow live editing
    home.activation.initWaybarConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      [ -f "$HOME/.config/waybar/config.jsonc" ] || install -Dm644 "${assetsPath}/config/waybar/config.jsonc" "$HOME/.config/waybar/config.jsonc"
      [ -f "$HOME/.config/waybar/style.css" ] || install -Dm644 "${assetsPath}/config/waybar/style.css" "$HOME/.config/waybar/style.css"
    '';
  };
}
