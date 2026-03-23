{ ... }: {
  flake.homeManagerModules.bitwarden = { pkgs, ... }: {
    home.packages = [ pkgs.bitwarden-desktop ];
  };
}
