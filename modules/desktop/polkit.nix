{ ... }: {
  flake.nixosModules.polkit = { pkgs, ... }: {
    security.polkit.enable = true;

    # Auto-start polkit agent
    systemd.user.services.polkit-gnome-agent = {
      description = "GNOME Polkit Authentication Agent";
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
