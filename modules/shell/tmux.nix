{ ... }: {
  flake.homeManagerModules.tmux = { pkgs, ... }: {
    programs.tmux = {
      enable = true;
      terminal = "tmux-256color";
      mouse = true;
      keyMode = "vi";
      baseIndex = 1;
      escapeTime = 0;
      historyLimit = 50000;

      extraConfig = ''
        set -ag terminal-overrides ",xterm-256color:RGB"
        set -g renumber-windows on
        set -g set-clipboard on
        set -g status-position top
      '';
    };
  };
}
