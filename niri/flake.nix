{
  description = "Flake exporting a configured niri package";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.wrappers.url = "github:BirdeeHub/nix-wrapper-modules";
  inputs.wrappers.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    {
      self,
      nixpkgs,
      wrappers,
      ...
    }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all;
      module = ./module.nix;
      wrapper = wrappers.lib.evalModule module;
    in
    {
      overlays = {
        niri = final: prev: { niri = wrapper.config.wrap { pkgs = final; }; };
        default = self.overlays.niri;
      };
      wrapperModules = {
        niri = module;
        default = self.wrapperModules.niri;
      };
      wrappers = {
        niri = wrapper.config;
        default = self.wrappers.niri;
      };
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          niri = wrapper.config.wrap { inherit pkgs; };
          default = self.packages.${system}.niri;
        }
      );
      # `wrappers.niri.enable = true`
      nixosModules = {
        default = self.nixosModules.niri;
        niri = wrappers.lib.mkInstallModule {
          name = "niri";
          value = module;
        };
      };
      # `wrappers.niri.enable = true`
      # You can set any of the options.
      # But that is how you enable it.
      homeModules = {
        default = self.homeModules.niri;
        niri = wrappers.lib.mkInstallModule {
          name = "niri";
          value = module;
          loc = [
            "home"
            "packages"
          ];
        };
      };
    };
}
