{pkgs, ...}: {
  imports = [
    ./autoCmd.nix
    ./cmp.nix # should be replaced by blink later
    ./keymaps.nix
    ./options.nix
    ./plugins/alpha.nix
    # ./plugins/blink.nix # still need to check snippet with highlighting.
    ./plugins/bufferline.nix
    # ./plugins/chatgpt.nix # no use
    # ./plugins/claude-code.nix # can be replaced by toggle term
    (import ./plugins/copilot.nix {inherit pkgs;})
    ./plugins/comment.nix
    ./plugins/conjure.nix
    # ./plugins/efmls-configs.nix # does not work
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
    # ./plugins/nvim-autopairs.nix
    ./plugins/nvim-tree.nix
    ./plugins/project.nix
    # ./plugins/quarto.nix # does not work
    ./plugins/telescope-harpoon.nix
    ./plugins/toggleterm.nix
    (import ./plugins/treesitter.nix {inherit pkgs;})
    ./plugins/vimtex.nix
    ./plugins/whichkey.nix
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

      -- vim.lsp.handlers["textDocument/hover"] =
      --   vim.lsp.with(vim.lsp.handlers.hover, {
      --     border = "rounded",
      --   })
      --
      -- vim.lsp.handlers["textDocument/signatureHelp"] =
      --   vim.lsp.with(vim.lsp.handlers.signature_help, {
      --     border = "rounded",
      -- })
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf

          vim.keymap.set("n", "K", function()
            vim.lsp.buf.hover({ border = "rounded" })
          end, { buffer = bufnr, desc = "LSP Hover" })

          vim.keymap.set({ "n", "i" }, "<C-k>", function()
            vim.lsp.buf.signature_help({ border = "rounded" })
          end, { buffer = bufnr, desc = "LSP Signature Help" })
        end,
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
