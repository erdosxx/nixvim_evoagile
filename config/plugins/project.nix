{
  plugins.project-nvim = {
    enable = true;
    enableTelescope = true;
    settings = {
      active = true;
      on_config_done = null;
      manual_mode = false;

      detection_methods = [ "pattern" ];

      patterns =
        [ ".git" "_darcs" ".hg" ".bzr" ".svn" "Makefile" "package.json" ];
      show_hidden = false;
      silent_chdir = true;

      ignore_lsp = [ ];
      datapath = { __raw = "vim.fn.stdpath('data')"; };
    };
  };
}
