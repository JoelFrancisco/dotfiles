{ ... }:

let
  # Path to omarchy assets in the Nix store
  assetsPath = ../../assets;
in
{
  flake.nixosModules.hyprland = { pkgs, ... }: {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
    };

    environment.systemPackages = with pkgs; [
      hyprlock
      hypridle
      hyprsunset
      hyprpicker
    ];

    # PAM integration for hyprlock
    security.pam.services.hyprlock = { };
  };

  flake.homeManagerModules.hyprland = { lib, pkgs, ... }: {
    home.file.".config/hypr/hyprland.conf".text = ''
      # Omarchy NixOS - Hyprland configuration
      # Default configs from the Nix store (do not edit)
      source = ${assetsPath}/default/hypr/autostart.conf
      source = ${assetsPath}/default/hypr/bindings/media.conf
      source = ${assetsPath}/default/hypr/bindings/clipboard.conf
      source = ${assetsPath}/default/hypr/bindings/tiling-v2.conf
      source = ${assetsPath}/default/hypr/bindings/utilities.conf
      source = ${assetsPath}/default/hypr/envs.conf
      source = ${assetsPath}/default/hypr/looknfeel.conf
      source = ${assetsPath}/default/hypr/input.conf
      source = ${assetsPath}/default/hypr/windows.conf
      source = ~/.config/omarchy/current/theme/hyprland.conf

      # User overrides (edit these freely)
      source = ~/.config/hypr/monitors.conf
      source = ~/.config/hypr/input.conf
      source = ~/.config/hypr/bindings.conf
      source = ~/.config/hypr/looknfeel.conf
      source = ~/.config/hypr/autostart.conf
    '';

    # Symlink ~/.local/share/omarchy to Nix store assets so all default
    # source = ~/.local/share/omarchy/... paths in config files work
    home.file.".local/share/omarchy".source = assetsPath;

    # Copy user-editable config files only if they don't already exist
    home.activation.initHyprConfigs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      for f in monitors.conf input.conf bindings.conf looknfeel.conf autostart.conf hypridle.conf hyprlock.conf hyprsunset.conf xdph.conf; do
        [ -f "$HOME/.config/hypr/$f" ] || install -Dm644 "${assetsPath}/config/hypr/$f" "$HOME/.config/hypr/$f"
      done
    '';
  };
}
