{
  plugins.illuminate = {
    enable = true;

    providers = [ "lsp" "treesitter" "regex" ];
    delay = 200;
    filetypesDenylist = [
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
    filetypesAllowlist = [ ];
    modesDenylist = [ ];
    modesAllowlist = [ ];
    providersRegexSyntaxAllowlist = [ ];
    providersRegexSyntaxDenylist = [ ];
    underCursor = true;
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

  extraConfigLua = # lua
    ''
      vim.g.Illuminate_ftblacklist = {'alpha', 'NvimTree'}
    '';
}
