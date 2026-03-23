{ ... }:

let
  assetsPath = ../../assets;
in
{
  flake.homeManagerModules.omarchy-scripts = { lib, pkgs, ... }:
    let
      # Scripts to exclude (Arch-specific or not applicable to NixOS)
      excludedScripts = [
        "omarchy-branch-set"
        "omarchy-channel-set"
        "omarchy-migrate"
        "omarchy-npx-install"
        "omarchy-pkg-add"
        "omarchy-pkg-aur-add"
        "omarchy-pkg-aur-install"
        "omarchy-pkg-aur-remove"
        "omarchy-pkg-check"
        "omarchy-pkg-install"
        "omarchy-pkg-missing"
        "omarchy-pkg-present"
        "omarchy-pkg-remove"
        "omarchy-reinstall"
        "omarchy-reinstall-configs"
        "omarchy-reinstall-packages"
        "omarchy-refresh-config"
        "omarchy-refresh-hyprland"
        "omarchy-refresh-waybar"
        "omarchy-refresh-walker"
        "omarchy-refresh-terminal"
        "omarchy-refresh-swayosd"
        "omarchy-remove-preinstalls"
        "omarchy-update"
        "omarchy-update-available"
        "omarchy-update-system-pkgs"
        "omarchy-upload-log"
      ];

      # Runtime dependencies for the scripts
      runtimeDeps = with pkgs; [
        hyprland
        grim
        slurp
        wl-clipboard
        jq
        brightnessctl
        playerctl
        pamixer
        libnotify
        imagemagick
        satty
        gum
        walker
        coreutils
        gnused
        gnugrep
        findutils
        procps
        systemd
        swaybg
        swayosd
        mako
        kitty
        bash
        curl
        wget
      ];

      omarchyAssets = pkgs.stdenvNoCC.mkDerivation {
        pname = "omarchy-assets";
        version = "3.4.2";
        src = assetsPath;
        dontBuild = true;
        installPhase = ''
          mkdir -p $out
          cp -r default $out/
          cp -r themes $out/
          cp -r config $out/
          cp -r templates $out/
          cp -r applications $out/
        '';
      };

      omarchyScripts = pkgs.stdenvNoCC.mkDerivation {
        pname = "omarchy-scripts";
        version = "3.4.2";
        src = "${assetsPath}/bin";

        nativeBuildInputs = [ pkgs.makeWrapper ];

        dontBuild = true;

        installPhase = ''
          mkdir -p $out/bin

          for script in $src/omarchy-*; do
            name=$(basename "$script")

            # Skip excluded scripts
            ${lib.concatStringsSep "\n" (map (s: ''
              [ "$name" = "${s}" ] && continue
            '') excludedScripts)}

            install -m755 "$script" "$out/bin/$name"
            wrapProgram "$out/bin/$name" \
              --prefix PATH : "${lib.makeBinPath runtimeDeps}" \
              --set OMARCHY_PATH "${omarchyAssets}"
          done

          # Add NixOS-specific replacement scripts
          cat > $out/bin/omarchy-rebuild << 'EOF'
          #!/bin/bash
          echo "Rebuilding NixOS configuration..."
          sudo nixos-rebuild switch --flake /home/joel/Work/nixos/dotfiles#$(hostname)
          EOF
          chmod +x $out/bin/omarchy-rebuild

          cat > $out/bin/omarchy-generations << 'EOF'
          #!/bin/bash
          sudo nix-env --list-generations -p /nix/var/nix/profiles/system
          EOF
          chmod +x $out/bin/omarchy-generations
        '';
      };
    in
    {
      home.packages = [ omarchyScripts ];
    };
}
