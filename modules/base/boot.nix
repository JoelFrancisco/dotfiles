{ ... }: {
  flake.nixosModules.boot = { pkgs, ... }: {
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    boot.plymouth.enable = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}
