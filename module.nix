{ inputs, nixpkgs-unfree, pkgs, ... }: {
  imports = [ inputs.nixvim.homeModules.nixvim ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    # Additional NixVim settings can go here
    imports = [ (import ./config { inherit inputs nixpkgs-unfree pkgs; }) ];
  };
}
