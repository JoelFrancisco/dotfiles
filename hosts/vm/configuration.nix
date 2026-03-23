{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "omarchy-vm";

  # Use GRUB instead of systemd-boot (BIOS VM)
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
  };

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

  # SSH access
  services.openssh.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  # QEMU guest agent for better host integration
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  system.stateVersion = "25.05";
}
