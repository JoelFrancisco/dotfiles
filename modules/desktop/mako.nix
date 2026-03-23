{ ... }:

let
  assetsPath = ../../assets;
in
{
  flake.nixosModules.mako = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.mako ];
  };

  flake.homeManagerModules.mako = { lib, ... }: {
    home.activation.initMakoConfig = lib.hm.dag.entryAfter [ "writeBoundary" "initOmarchyTheme" ] ''
      [ -d "$HOME/.config/mako" ] || mkdir -p "$HOME/.config/mako"
      # Use themed mako config (which includes core.ini via include directive)
      THEMED_MAKO="$HOME/.config/omarchy/current/theme/mako.ini"
      if [ -f "$THEMED_MAKO" ]; then
        cp "$THEMED_MAKO" "$HOME/.config/mako/config"
      else
        [ -f "$HOME/.config/mako/config" ] || install -Dm644 "${assetsPath}/default/mako/core.ini" "$HOME/.config/mako/config"
      fi
    '';
  };
}
