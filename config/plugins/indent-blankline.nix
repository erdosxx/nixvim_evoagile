{
  plugins.indent-blankline = {
    enable = true;
    settings = {
      exclude = {
        filetypes = [
          "lspinfo"
          "packer"
          "checkhealth"
          "help"
          "man"
          "gitcommit"
          "TelescopePrompt"
          "TelescopeResults"
          "startify"
          "dashboard"
          "neogitstatus"
          "NvimTree"
          "Trouble"
        ];
      };
      indent = { char = "▏"; };
      scope = {
        show_start = false;
        show_end = false;
      };
    };
  };
}
