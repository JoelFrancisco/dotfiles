{ ... }: {
  flake.homeManagerModules.lazygit = { pkgs, ... }: {
    programs.lazygit = {
      enable = true;
    };
  };
}
