{
  description = "Flake exporting a configured alacritty package";
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
        alacritty = final: prev: { alacritty = wrapper.config.wrap { pkgs = final; }; };
        default = self.overlays.alacritty;
      };
      wrapperModules = {
        alacritty = module;
        default = self.wrapperModules.alacritty;
      };
      wrappers = {
        alacritty = wrapper.config;
        default = self.wrappers.alacritty;
      };
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          alacritty = wrapper.config.wrap { inherit pkgs; };
          default = self.packages.${system}.alacritty;
        }
      );
      # `wrappers.alacritty.enable = true`
      nixosModules = {
        default = self.nixosModules.alacritty;
        alacritty = wrappers.lib.mkInstallModule {
          name = "alacritty";
          value = module;
        };
      };
      # `wrappers.alacritty.enable = true`
      # You can set any of the options.
      # But that is how you enable it.
      homeModules = {
        default = self.homeModules.alacritty;
        alacritty = wrappers.lib.mkInstallModule {
          name = "alacritty";
          value = module;
          loc = [
            "home"
            "packages"
          ];
        };
      };
    };
}
