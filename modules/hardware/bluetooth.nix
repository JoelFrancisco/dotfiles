{ ... }: {
  flake.nixosModules.bluetooth = { config, lib, pkgs, ... }: {
    options.omarchy.hardware.bluetooth.enable = lib.mkEnableOption "Bluetooth support" // {
      default = true;
    };

    config = lib.mkIf config.omarchy.hardware.bluetooth.enable {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
      };

      services.blueman.enable = true;
    };
  };
}
