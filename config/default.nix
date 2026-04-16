{pkgs, ...}: {
  imports = [
    ./autoCmd.nix
    ./keymaps.nix
    ./options.nix
    ./plugins/alpha.nix
    ./plugins/bufferline.nix
    # ./plugins/chatgpt.nix
    ./plugins/claude-code.nix
    ./plugins/comment.nix
    ./plugins/conjure.nix
    # ./plugins/efmls-configs.nix
    (import ./plugins/extraPlugins.nix {inherit pkgs;})
    ./plugins/gitsigns.nix
    ./plugins/illuminate.nix
    ./plugins/indent-blankline.nix
    ./plugins/lean.nix
    ./plugins/lsp.nix
    ./plugins/lualine.nix
    ./plugins/luasnip.nix
    ./plugins/navic.nix
    ./plugins/none-ls.nix
    ./plugins/nvim-autopairs.nix
    ./plugins/nvim-tree.nix
    ./plugins/project.nix
    # ./plugins/quarto.nix
    ./plugins/telescope-harpoon.nix
    ./plugins/toggleterm.nix
    (import ./plugins/treesitter.nix {inherit pkgs;})
    ./plugins/vimtex.nix
    ./plugins/whichkey.nix
    (import ./cmp.nix {inherit pkgs;})
  ];

  nixpkgs.config.allowUnfree = true;

  colorschemes.tokyonight.enable = true;

  globals = {
    mapleader = "-";
    maplocalleader = " ";
  };

  diagnostic.settings = {
    virtual_text = false; # disable virtual text
    signs = {
      active = "signs"; # show signs
    };
    update_in_insert = true;
    underline = true;
    severity_sort = true;
    float = {
      focusable = true;
      style = "minimal";
      border = "rounded";
      source = "always";
      header = "";
      prefix = "";
    };
  };

  extraConfigLua =
    # lua
    ''
      vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format()' ]])

      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN]  = "",
            [vim.diagnostic.severity.HINT]  = "",
            [vim.diagnostic.severity.INFO]  = "",
          }
        }
      })

      vim.lsp.handlers["textDocument/hover"] =
        vim.lsp.with(vim.lsp.handlers.hover, {
          border = "rounded",
        })

      vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, {
          border = "rounded",
      })

      -- from treesitter
      vim.g.skip_ts_context_commentstring_module = true

      -- disable default keymapping from jupyter-vim
      vim.g.jupyter_mapkeys = 0
    '';

  plugins = {
    web-devicons.enable = true;
    barbecue.enable = true;
    rainbow-delimiters.enable = true;
    coverage.enable = true;
  };
}
