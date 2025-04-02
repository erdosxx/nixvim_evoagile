# module.nix
{ inputs, nixpkgs-unfree, pkgs, ... }: {
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    # Additional NixVim settings can go here
    imports = [
      (import ./config {
        inherit nixpkgs-unfree;
        inherit pkgs;
      }) # Your existing configuration
    ];
  };
}
