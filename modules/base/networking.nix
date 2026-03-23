{ ... }: {
  flake.nixosModules.networking = {
    networking = {
      networkmanager.enable = true;
      wireless.iwd.enable = true;
      networkmanager.wifi.backend = "iwd";

      firewall.enable = true;
    };
  };
}
