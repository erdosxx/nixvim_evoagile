{
  plugins.illuminate = {
    enable = true;

    settings = {
      delay = 200;
      providers = [ "lsp" "treesitter" "regex" ];
      filetypes_allowlist = [ ];
      filetypes_denylist = [
        "dirvish"
        "fugitive"
        "alpha"
        "NvimTree"
        "packer"
        "neogitstatus"
        "Trouble"
        "lir"
        "Outline"
        "spectre_panel"
        "toggleterm"
        "DressingSelect"
        "TelescopePrompt"
      ];
      under_cursor = true;
      modes_denylist = [ ];
      modes_allowlist = [ ];
      providers_regex_syntax_allowlist = [ ];
      providers_regex_syntax_denylist = [ ];
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<localleader>9";
      action =
        ''<cmd>lua require"illuminate".goto_next_reference{wrap=true}<cr>'';
      options = {
        desc = "go to next referernce";
        noremap = true;
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<localleader>8";
      action =
        ''<cmd>lua require"illuminate".goto_prev_reference{wrap=true}<cr>'';
      options = {
        desc = "go to previous referernce";
        noremap = true;
        silent = true;
      };
    }
  ];

  extraConfigLua =
    # lua
    ''
      vim.g.Illuminate_ftblacklist = {'alpha', 'NvimTree'}
    '';
}
