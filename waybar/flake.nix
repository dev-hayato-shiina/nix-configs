{
  description = "Flake exporting a configured waybar package";
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
        waybar = final: prev: { waybar = wrapper.config.wrap { pkgs = final; }; };
        default = self.overlays.waybar;
      };
      wrapperModules = {
        waybar = module;
        default = self.wrapperModules.waybar;
      };
      wrappers = {
        waybar = wrapper.config;
        default = self.wrappers.waybar;
      };
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        {
          waybar = wrapper.config.wrap { inherit pkgs; };
          default = self.packages.${system}.waybar;
        }
      );
      # `wrappers.waybar.enable = true`
      nixosModules = {
        default = self.nixosModules.waybar;
        waybar = wrappers.lib.mkInstallModule {
          name = "waybar";
          value = module;
        };
      };
      # `wrappers.waybar.enable = true`
      # You can set any of the options.
      # But that is how you enable it.
      homeModules = {
        default = self.homeModules.waybar;
        waybar = wrappers.lib.mkInstallModule {
          name = "waybar";
          value = module;
          loc = [
            "home"
            "packages"
          ];
        };
      };
    };
}
