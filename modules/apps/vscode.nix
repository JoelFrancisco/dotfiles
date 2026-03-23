{ ... }: {
  flake.homeManagerModules.vscode = { pkgs, ... }: {
    programs.vscode = {
      enable = true;
      package = pkgs.vscode;
    };
  };
}
