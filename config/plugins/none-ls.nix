{
  plugins.none-ls = {
    enable = true;
    sources = {
      diagnostics = {
        mypy.enable = true;
        yamllint.enable = true;
        zsh.enable = true;
      };

      formatting = {
        bibclean.enable = true;
        black = {
          enable = true;
          settings = {
            timeout = 2000;
            extra_args = [ "--line-length" "79" "--fast" ];
          };
        };
        nixfmt.enable = true;
        prettier = {
          enable = true;
          disableTsServerFormatter = true;
          settings = {
            disabled_filetypes = [ "lua" ];
            extra_args = [ "--no-semi" "--single-quote" "--jsx-single-quote" ];
          };
        };
        shfmt = {
          enable = true;
          settings = { extra_args = [ "-i" "2" "-ci" ]; };
        };
        stylua = {
          enable = true;
          settings = { extra_args = [ "--column-width" "79" ]; };
        };
        # not work
        # just.enable = true;
      };
    };
  };
}
