{
  plugins.vimtex = {
    enable = true;
    settings = {
      compiler_method = "latexrun";
      toc_config = {
        split_pos = "\n              vert\n              topleft\n              ";
        split_width = 40;
      };
      view_method = "zathura";
      imaps_leader = "¬";
    };
  };
}
