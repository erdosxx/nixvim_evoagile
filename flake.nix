{
  description = "Evoagile nixvim configuration";

  inputs = {
    nixvim = {
      url = "github:nix-community/nixvim";
      # url =
      #   "github:nix-community/nixvim?rev=41844750e55f17b1385d5b09ca7ade5f11f49506";
      inputs.nixpkgs.follows = "nixpkgs-small-fix";
    };
    nixpkgs-small-fix.url = "github:nixos/nixpkgs?rev=f496248152e1ad8c61b59a6739cc499b447168e4";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = {
    nixvim,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      flake = {
        homeModules.default = {
          pkgs,
          pkgs-unstable,
          ...
        }: {
          imports = [(import ./module.nix {inherit inputs pkgs pkgs-unstable;})];
        };
      };

      perSystem = {system, ...}: let
        nixvimLib = nixvim.lib.${system};
        nixvim' = nixvim.legacyPackages.${system};
        nixvimModule = {
          inherit system; # or alternatively, set `pkgs`
          module = import ./config {inherit inputs pkgs pkgs-unstable;}; # import the module directly
          # You can use `extraSpecialArgs` to pass additional arguments to your module files
          extraSpecialArgs = {
          };
        };
        nvim = nixvim'.makeNixvimWithModule nixvimModule;
        unfree = system: nixpkgs':
          import nixpkgs' {
            inherit system;
            config.allowUnfree = true;
          };
        pkgs = unfree system inputs.nixpkgs;
        pkgs-unstable = unfree system inputs.nixpkgs-unstable;
      in {
        checks = {
          # Run `nix flake check .` to verify that your config is not broken
          default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
        };

        packages = {
          # Lets you run `nix run .` to start nixvim
          default = nvim;
        };

        # Add formatter for each system
        formatter = inputs.nixpkgs.legacyPackages.${system}.alejandra;

        devShells.default = pkgs.mkShell {
          name = "nixvim-dev";
          # buildInputs = with pkgs; [ sops age ssh-to-age ];
        };
      };
    };
}
