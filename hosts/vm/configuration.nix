{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "omarchy-vm";

  # No GPU hardware module needed — QEMU virtio/QXL works out of the box

  # Disable bluetooth in VM
  omarchy.hardware.bluetooth.enable = false;

  # User account
  users.users.joel = {
    isNormalUser = true;
    description = "Joel";
    initialPassword = "nixos";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
    ];
    shell = pkgs.bash;
  };

  # QEMU guest agent for better host integration
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  system.stateVersion = "25.05";
}
