{ ... }:

let
  assetsPath = ../../assets;
in
{
  flake.homeManagerModules.bash = { config, pkgs, lib, ... }: {
    programs.bash = {
      enable = true;

      shellAliases = {
        # File system
        ls = "eza -lh --group-directories-first --icons=auto";
        lsa = "ls -a";
        lt = "eza --tree --level=2 --long --icons --git";
        lta = "lt -a";

        # Directories
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";

        # Tools
        cy = "claude --dangerously-skip-permissions";
        d = "docker";
        t = "tmux attach || tmux new -s Work";

        # Git
        g = "git";
        gcm = "git commit -m";
        gcam = "git commit -a -m";
        gcad = "git commit -a --amend";
      };

      bashrcExtra = ''
        # Omarchy bash extensions
        source "${assetsPath}/default/bash/envs" 2>/dev/null || true
        source "${assetsPath}/default/bash/shell" 2>/dev/null || true
        source "${assetsPath}/default/bash/functions" 2>/dev/null || true
        source "${assetsPath}/default/bash/init" 2>/dev/null || true

        # Load omarchy bash functions
        for fn_file in "${assetsPath}/default/bash/fns"/*; do
          [ -f "$fn_file" ] && source "$fn_file"
        done

        # FZF with kitty image preview
        if [[ "$TERM" == "xterm-kitty" ]]; then
          alias ff="fzf --preview 'case \$(file --mime-type -b {}) in image/*) kitty icat --clear --transfer-mode=memory --stdin=no --place=\''${FZF_PREVIEW_COLUMNS}x\''${FZF_PREVIEW_LINES}@0x0 {} ;; *) bat --style=numbers --color=always {} ;; esac'"
        else
          alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
        fi
        alias eff='$EDITOR "$(ff)"'

        # Neovim shortcut
        n() { if [ "$#" -eq 0 ]; then command nvim . ; else command nvim "$@"; fi; }

        # Open files with default app
        open() ( xdg-open "$@" >/dev/null 2>&1 & )
      '';

      initExtra = ''
        # Zoxide integration
        if command -v zoxide &> /dev/null; then
          eval "$(zoxide init bash)"
        fi

        # Inputrc settings
        [[ $- == *i* ]] && bind -f "${assetsPath}/default/bash/inputrc" 2>/dev/null || true
      '';
    };

    home.packages = with pkgs; [
      eza
      bat
      fd
      ripgrep
      fzf
      jq
      tldr
      tree
      dust
      zoxide
      fastfetch
    ];
  };
}
