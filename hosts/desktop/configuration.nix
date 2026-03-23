{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "omarchy-desktop";

  # Enable NVIDIA GPU
  omarchy.hardware.nvidia.enable = true;

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
      "libvirtd"
    ];
    shell = pkgs.bash;
  };

  # Docker
  virtualisation.docker.enable = true;

  # Printing
  services.printing.enable = true;

  system.stateVersion = "25.05";
}
