{
  description = "Flake exporting a configured zsh package";
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
        zsh = final: prev: { zsh = wrapper.config.wrap { pkgs = final; }; };
        default = self.overlays.zsh;
      };
      wrapperModules = {
        zsh = module;
        default = self.wrapperModules.zsh;
      };
      wrappers = {
        zsh = wrapper.config;
        default = self.wrappers.zsh;
      };
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          zsh = wrapper.config.wrap { inherit pkgs; };
          default = self.packages.${system}.zsh;
        }
      );
      # `wrappers.zsh.enable = true`
      nixosModules = {
        default = self.nixosModules.zsh;
        zsh = wrappers.lib.mkInstallModule {
          name = "zsh";
          value = module;
        };
      };
      # `wrappers.zsh.enable = true`
      # You can set any of the options.
      # But that is how you enable it.
      homeModules = {
        default = self.homeModules.zsh;
        zsh = wrappers.lib.mkInstallModule {
          name = "zsh";
          value = module;
          loc = [
            "home"
            "packages"
          ];
        };
      };
    };
}
