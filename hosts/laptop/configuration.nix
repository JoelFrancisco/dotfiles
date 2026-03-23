{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "omarchy-laptop";

  # Enable Intel iGPU
  omarchy.hardware.intel.enable = true;

  # User account
  users.users.joel = {
    isNormalUser = true;
    description = "Joel";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "docker"
    ];
    shell = pkgs.bash;
  };

  # Docker
  virtualisation.docker.enable = true;

  # Printing
  services.printing.enable = true;

  # Power management for laptop
  services.thermald.enable = true;
  services.power-profiles-daemon.enable = true;

  system.stateVersion = "25.05";
}
