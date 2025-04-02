# module.nix
{ inputs, nixpkgs-unfree, ... }: {
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    # Additional NixVim settings can go here
    imports = [
      (import ./config {
        inherit nixpkgs-unfree;
      }) # Your existing configuration
    ];
  };
}
