{
  description = "Evoagile nixvim configuration";

  inputs = {
    nixvim = {
      # url = "github:nix-community/nixvim";
      url =
        "github:nix-community/nixvim?rev=754b8df7e37be04b7438decee5a5aa18af72cbe1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = { nixvim, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems =
        [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      flake = {
        homeManagerModules.default = { pkgs, ... }:
          let
            # system = config.nixpkgs.system;
            # system = "x86_64-linux";
            system = pkgs.system;
            nixpkgs-unfree = import inputs.nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
            # pkgs = inputs.nixpkgs.legacyPackages.${system};
          in {
            imports =
              [ (import ./module.nix { inherit inputs nixpkgs-unfree pkgs; }) ];
          };
      };

      perSystem = { system, ... }:
        let
          nixvimLib = nixvim.lib.${system};
          nixvim' = nixvim.legacyPackages.${system};
          nixvimModule = {
            inherit system; # or alternatively, set `pkgs`
            module = import ./config; # import the module directly
            # You can use `extraSpecialArgs` to pass additional arguments to your module files
            extraSpecialArgs = {
              # inherit (inputs) foo;
              nixpkgs-unfree = import inputs.nixpkgs {
                inherit system;
                config.allowUnfree = true;
              };
            };
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
        };
    };
}
