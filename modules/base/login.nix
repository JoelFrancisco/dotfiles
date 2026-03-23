{ ... }:

let
  assetsPath = ../../assets;

  # Package the SDDM theme as a derivation if theme assets exist
  # For now, use a simple SDDM configuration
in
{
  flake.nixosModules.login = {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    # UWSM for session management
    programs.uwsm = {
      enable = true;
      waylandCompositors.hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/Hyprland";
      };
    };
  };
}
