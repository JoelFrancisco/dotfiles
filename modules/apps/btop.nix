{ ... }: {
  flake.homeManagerModules.btop = { pkgs, ... }: {
    programs.btop = {
      enable = true;
      settings = {
        theme_background = false;
        vim_keys = true;
      };
    };

    # Themed btop config is applied via the theme module's activation script
    # (generates btop.theme from btop.theme.tpl)
  };
}
