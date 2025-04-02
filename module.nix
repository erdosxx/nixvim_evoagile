# module.nix
{ inputs, ... }: {
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    # Additional NixVim settings can go here
    imports = [
      ./config # Your existing configuration
    ];
  };
}
