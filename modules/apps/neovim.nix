{ ... }: {
  flake.homeManagerModules.neovim = { lib, pkgs, ... }: {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      extraPackages = with pkgs; [
        # LSP servers and tools used by LazyVim
        lua-language-server
        stylua
        nil # Nix LSP
        nixpkgs-fmt
        nodePackages.typescript-language-server
        nodePackages.vscode-langservers-extracted
        ripgrep
        fd
        gcc
        gnumake
        tree-sitter
      ];
    };

    # Clone LazyVim starter if nvim config doesn't exist
    home.activation.initLazyVim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -d "$HOME/.config/nvim" ]; then
        ${pkgs.git}/bin/git clone https://github.com/LazyVim/starter "$HOME/.config/nvim" 2>/dev/null && \
          rm -rf "$HOME/.config/nvim/.git" || true
      fi
    '';
  };
}
