{ ... }: {
  flake.nixosModules.nvidia = { config, lib, pkgs, ... }: {
    options.omarchy.hardware.nvidia.enable = lib.mkEnableOption "NVIDIA GPU support";

    config = lib.mkIf config.omarchy.hardware.nvidia.enable {
      hardware.nvidia = {
        modesetting.enable = true;
        open = true;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };

      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      boot.kernelParams = [ "nvidia-drm.modeset=1" ];

      environment.sessionVariables = {
        LIBVA_DRIVER_NAME = "nvidia";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        GBM_BACKEND = "nvidia-drm";
        WLR_NO_HARDWARE_CURSORS = "1";
      };
    };
  };
}
