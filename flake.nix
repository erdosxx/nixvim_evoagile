{
  description = "Evoagile nixvim configuration";

  inputs = {
    nixvim = {
      url = "github:nix-community/nixvim";
      # url =
      #   "github:nix-community/nixvim?rev=e537d4a6b4c1c81f8b71dfd916fdf970d0d5c987";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = {
    nixvim,
    flake-parts,
    ...
  } @ inputs: let
    unfree = system:
      import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];

      flake = {
        homeManagerModules.default = {pkgs, ...}: let
          nixpkgs-unfree = unfree pkgs.system;
        in {
          imports = [(import ./module.nix {inherit inputs nixpkgs-unfree pkgs;})];
        };
      };

      perSystem = {system, ...}: let
        nixvimLib = nixvim.lib.${system};
        nixvim' = nixvim.legacyPackages.${system};
        nixvimModule = {
          inherit system; # or alternatively, set `pkgs`
          module = import ./config; # import the module directly
          # You can use `extraSpecialArgs` to pass additional arguments to your module files
          extraSpecialArgs = {nixpkgs-unfree = unfree system;};
        };
        nvim = nixvim'.makeNixvimWithModule nixvimModule;
      in {
        checks = {
          # Run `nix flake check .` to verify that your config is not broken
          default =
            nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
        };

        packages = {
          # Lets you run `nix run .` to start nixvim
          default = nvim;
        };

        # Add formatter for each system
        formatter = inputs.nixpkgs.legacyPackages.${system}.alejandra;
      };
    };
}
