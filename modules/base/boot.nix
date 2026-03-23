{ ... }: {
  flake.nixosModules.boot = { lib, pkgs, ... }: {
    boot.loader = {
      systemd-boot.enable = lib.mkDefault true;
      efi.canTouchEfiVariables = lib.mkDefault true;
    };

    boot.plymouth.enable = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}
