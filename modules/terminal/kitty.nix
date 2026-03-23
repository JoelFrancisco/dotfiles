{ ... }: {
  flake.homeManagerModules.kitty = { config, pkgs, ... }: {
    programs.kitty = {
      enable = true;

      settings = {
        font_family = "JetBrainsMono Nerd Font";
        bold_font = "auto";
        italic_font = "auto";
        bold_italic_font = "auto";
        font_size = 13;

        cursor_shape = "beam";
        cursor_blink_interval = 0;

        scrollback_lines = 10000;
        copy_on_select = "clipboard";

        enable_audio_bell = false;
        visual_bell_duration = 0;

        window_padding_width = 8;
        confirm_os_window_close = 0;

        # Themed colors are applied via ~/.config/omarchy/current/theme/kitty.conf
        include = "~/.config/omarchy/current/theme/kitty.conf";
      };
    };

    home.packages = [ pkgs.xdg-terminal-exec ];

    # Set kitty as the default terminal
    home.sessionVariables.TERMINAL = "kitty";

    # xdg-terminal-exec config
    home.file.".config/xdg-terminals.list".text = "kitty\n";
  };
}
