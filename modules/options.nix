# Declare flake.nixosModules and flake.homeManagerModules as mergeable options
# so multiple dendritic modules can each contribute their own definitions.
{ lib, ... }: {
  options.flake = {
    nixosModules = lib.mkOption {
      type = lib.types.attrsOf lib.types.raw;
      default = {};
    };
    homeManagerModules = lib.mkOption {
      type = lib.types.attrsOf lib.types.raw;
      default = {};
    };
  };
}
