{ inputs, config, ... }:

let
  system = "x86_64-linux";
  specialArgs = { inherit inputs; };

  nixosModules = builtins.attrValues config.flake.nixosModules;
  hmModules = builtins.attrValues config.flake.homeManagerModules;

  commonModules = nixosModules ++ [
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = specialArgs;
        users.joel = {
          imports = hmModules;
          home.stateVersion = "25.05";
        };
      };
    }
  ];
in
{
  flake.nixosConfigurations = {
    desktop = inputs.nixpkgs.lib.nixosSystem {
      inherit system specialArgs;
      modules = commonModules ++ [
        ../hosts/desktop/configuration.nix
      ];
    };

    laptop = inputs.nixpkgs.lib.nixosSystem {
      inherit system specialArgs;
      modules = commonModules ++ [
        ../hosts/laptop/configuration.nix
      ];
    };
  };
}
