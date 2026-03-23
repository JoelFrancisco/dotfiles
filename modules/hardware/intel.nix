{ ... }: {
  flake.nixosModules.intel = { config, lib, pkgs, ... }: {
    options.omarchy.hardware.intel.enable = lib.mkEnableOption "Intel integrated GPU support";

    config = lib.mkIf config.omarchy.hardware.intel.enable {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          intel-media-driver # VA-API (Broadwell+)
          vaapiIntel # VA-API (older Intel)
          vaapiVdpau
          libvdpau-va-gl
          vulkan-intel
        ];
      };

      environment.sessionVariables = {
        LIBVA_DRIVER_NAME = "iHD";
      };
    };
  };
}
