{ ... }: {
  flake.homeManagerModules.git = { pkgs, ... }: {
    programs.git = {
      enable = true;
      lfs.enable = true;

      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
        rerere.enabled = true;
        column.ui = "auto";
        branch.sort = "-committerdate";
      };
    };

    home.packages = [ pkgs.gh ];
  };
}
