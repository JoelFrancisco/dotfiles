{ ... }:

let
  assetsPath = ../../assets;
in
{
  flake.nixosModules.walker = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.walker ];
  };

  flake.homeManagerModules.walker = { lib, ... }: {
    home.activation.initWalkerConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      [ -d "$HOME/.config/walker" ] || mkdir -p "$HOME/.config/walker"
      [ -f "$HOME/.config/walker/config.toml" ] || install -Dm644 "${assetsPath}/config/walker/config.toml" "$HOME/.config/walker/config.toml" 2>/dev/null || true
    '';
  };
}
