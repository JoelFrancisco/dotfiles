{ ... }:

let
  assetsPath = ../../assets;
in
{
  flake.homeManagerModules.chromium = { lib, pkgs, ... }: {
    programs.chromium = {
      enable = true;

      commandLineArgs = [
        "--ozone-platform-hint=auto"
        "--enable-features=TouchpadOverscrollHistoryNavigation"
      ];
    };

    # Copy chromium policies from omarchy defaults
    home.activation.initChromiumPolicies = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      POLICY_DIR="$HOME/.config/chromium/policies"
      mkdir -p "$POLICY_DIR/managed" "$POLICY_DIR/writable"
      if [ -d "${assetsPath}/default/chromium/policies/managed" ]; then
        for f in "${assetsPath}/default/chromium/policies/managed"/*.json; do
          [ -f "$f" ] && cp "$f" "$POLICY_DIR/managed/" 2>/dev/null || true
        done
      fi
    '';
  };
}
