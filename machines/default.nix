{
  inputs,
  lib,
  self,
  ...
}:
let
  hostsNames = lib.attrNames (
    lib.filterAttrs (n: v: v == "directory" && (builtins.readDir ./${n}) ? "default.nix") (
      builtins.readDir ./.
    )
  );

  mkHost =
    hostname:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit
          inputs
          hostname
          self
          ;
      };
      modules = [
        ./${hostname}
        self.nixosModules.codmod
        inputs.home-manager.nixosModules.home-manager
        inputs.ff.nixosModules.default
        inputs.ff.nixosModules.windowManagers
        inputs.ff.nixosModules.preservation
        inputs.preservation.nixosModules.preservation
        inputs.disko.nixosModules.disko
        {
          home-manager = {
            backupFileExtension = "bk";
            extraSpecialArgs = {
              inherit inputs;
            };
            useGlobalPkgs = true;
            useUserPackages = true;
          };
        }
      ];
    };
in
{
  flake.nixosConfigurations = lib.genAttrs hostsNames mkHost;
}
