# Declare flake.homeManagerModules as a mergeable option
# so multiple dendritic modules can each contribute their own definitions.
# (flake.nixosModules is already built-in to flake-parts)
{ lib, ... }: {
  options.flake = {
    homeManagerModules = lib.mkOption {
      type = lib.types.attrsOf lib.types.raw;
      default = {};
    };
  };
}
