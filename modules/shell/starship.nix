{ ... }: {
  flake.homeManagerModules.starship = { ... }: {
    programs.starship = {
      enable = true;
      enableBashIntegration = true;
    };
  };
}
