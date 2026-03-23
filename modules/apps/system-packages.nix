{ ... }: {
  # System-wide packages from omarchy-base.packages that aren't covered by other modules
  flake.nixosModules.system-packages = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      # System tools
      unzip
      wget
      curl
      whois
      inetutils
      inxi
      plocate
      less
      tree
      htop

      # File management
      nautilus
      gnome-disk-utility
      evince # PDF viewer
      imv # Image viewer
      xournalpp # Annotation
      yazi # Terminal file manager

      # Media
      mpv
      vlc
      ffmpegthumbnailer
      obs-studio
      kdePackages.kdenlive
      pinta # Image editor
      imagemagick
      gpu-screen-recorder

      # Office
      libreoffice-fresh
      gnome-calculator
      obsidian
      typora
      todoist-electron
      standardnotes

      # Communication
      localsend
      zoom-us
      telegram-desktop
      vesktop # Discord client

      # Browsers
      # zen-browser  # TODO: needs custom flake input (not in nixpkgs)
      brave

      # API clients
      yaak
      postman

      # Development
      zed-editor
      jetbrains.idea
      gcc
      clang
      llvm
      gnumake
      cmake
      python3
      ruby
      rustup
      nodejs

      # Wayland utilities
      wl-clipboard
      grim
      slurp
      satty # Screenshot annotation

      # Desktop integration
      gnome-keyring
      libsecret
      polkit_gnome
      gnome-themes-extra
      qt5.qtwayland
      kdePackages.qt6-wayland

      # Misc
      libqalculate
      xmlstarlet
      gum # TUI components
      brightnessctl
    ];

    # Docker
    virtualisation.docker = {
      enableOnBoot = true;
    };

    # Avahi/mDNS
    services.avahi = {
      enable = true;
      nssmdns4 = true;
    };

    # GNOME keyring
    services.gnome.gnome-keyring.enable = true;

    # Locate database
    services.locate = {
      enable = true;
      package = pkgs.plocate;
    };
  };

  flake.homeManagerModules.system-packages = { pkgs, ... }: {
    home.packages = with pkgs; [
      lazydocker
      spotify
    ];
  };
}
