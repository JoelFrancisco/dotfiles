{ ... }:

let
  assetsPath = ../../assets;
in
{
  flake.nixosModules.mako = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.mako ];
  };

  flake.homeManagerModules.mako = { lib, ... }: {
    home.activation.initMakoConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      [ -d "$HOME/.config/mako" ] || mkdir -p "$HOME/.config/mako"
      [ -f "$HOME/.config/mako/config" ] || install -Dm644 "${assetsPath}/default/mako/config" "$HOME/.config/mako/config"
    '';
  };
}
