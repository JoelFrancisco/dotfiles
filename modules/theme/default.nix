{ ... }:

let
  assetsPath = ../../assets;
in
{
  flake.homeManagerModules.theme = { config, lib, pkgs, ... }:
    let
      themeLib = import ../../lib/theme.nix { inherit lib; };
      cfg = config.omarchy.theme;

      # Parse the selected theme's colors.toml
      colorsFile = "${assetsPath}/themes/${cfg.name}/colors.toml";
      colors = themeLib.parseColorsToml colorsFile;

      # Generate themed config files from templates
      templateDir = "${assetsPath}/templates";

      generateThemedFile = templateName:
        let
          tplPath = "${templateDir}/${templateName}";
          outputName = lib.removeSuffix ".tpl" templateName;
        in
        {
          name = outputName;
          value = themeLib.applyTemplateFile colors tplPath;
        };

      # Templates relevant to this config (skip alacritty/ghostty since we only use kitty)
      relevantTemplates = [
        "btop.theme.tpl"
        "chromium.theme.tpl"
        "hyprland.conf.tpl"
        "hyprland-preview-share-picker.css.tpl"
        "hyprlock.conf.tpl"
        "kitty.conf.tpl"
        "mako.ini.tpl"
        "swayosd.css.tpl"
        "walker.css.tpl"
        "waybar.css.tpl"
      ];

      themedFiles = builtins.listToAttrs (map generateThemedFile relevantTemplates);
    in
    {
      options.omarchy.theme = {
        name = lib.mkOption {
          type = lib.types.str;
          default = "tokyo-night";
          description = "Omarchy theme name (must match a directory in assets/themes/)";
        };

        colors = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          default = colors;
          readOnly = true;
          description = "Parsed color values from the selected theme (read-only)";
        };
      };

      config = {
        # Set initial theme files via activation (mutable, not symlinked)
        home.activation.initOmarchyTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          THEME_DIR="$HOME/.config/omarchy/current/theme"
          mkdir -p "$THEME_DIR"

          ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: content: ''
            cat > "$THEME_DIR/${name}" << 'THEME_EOF'
            ${content}
            THEME_EOF
          '') themedFiles)}

          # Copy theme-specific extras (backgrounds, btop themes, etc.)
          THEME_SRC="${assetsPath}/themes/${cfg.name}"
          if [ -d "$THEME_SRC" ]; then
            for f in "$THEME_SRC"/*; do
              fname="$(basename "$f")"
              [ "$fname" = "colors.toml" ] && continue
              [ -f "$THEME_DIR/$fname" ] || cp "$f" "$THEME_DIR/$fname" 2>/dev/null || true
            done
          fi
        '';
      };
    };
}
