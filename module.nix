# module.nix
{ inputs, ... }: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./config # Your existing configuration
  ];

  programs.nixvim = {
    enable = true;
    # Additional NixVim settings can go here
  };
}
