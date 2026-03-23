{ ... }: {
  flake.nixosModules.swaybg = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.swaybg ];
  };
}
