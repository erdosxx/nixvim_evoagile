{ pkgs, ... }: {
  imports = [
    ./plugins/alpha.nix
    ./plugins/comment.nix
    ./plugins/nvim-autopairs.nix
    ./plugins/bufferline.nix
    ./plugins/illuminate.nix
    ./plugins/indent-blankline.nix
    ./plugins/lsp.nix
    ./plugins/lualine.nix
    ./plugins/luasnip.nix
    ./plugins/navic.nix
    ./plugins/none-ls.nix
    ./plugins/nvim-tree.nix
    ./plugins/project.nix
    ./plugins/telescope-harpoon.nix
    ./plugins/treesitter.nix
    ./plugins/whichkey.nix
    ./autoCmd.nix
    ./options.nix
    ./keymaps.nix
    ./cmp.nix
  ];

  colorschemes.tokyonight.enable = true;

  globals = {
    mapleader = "-";
    maplocalleader = " ";
  };

  diagnostics = {
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

      local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
      }

      for _, sign in ipairs(signs) do
      	vim.fn.sign_define(
      		sign.name,
      		{ texthl = sign.name, text = sign.text, numhl = "" }
      	)
      end

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
    '';

  # For updating treesitter.
  extraPackages = with pkgs; [ zig ];

  extraPlugins = [
    # (pkgs.vimUtils.buildVimPlugin {
    #   name = "julia-repl-vim";
    #   src = pkgs.fetchFromGitHub {
    #     owner = "erdosxx";
    #     repo = "julia-repl-vim";
    #     rev = "b2fc08feca51d1f6119ca291be6c7fca2fac7c45";
    #     hash = "sha256-JwOfLBNrR7GRK5IFmeklJK4Z7NOg+6ijOomCS41r4kM=";
    #   };
    # })
    (pkgs.vimUtils.buildVimPlugin {
      name = "julia-repl-vim";
      src = pkgs.fetchFromGitHub {
        owner = "andreypopp";
        repo = "julia-repl-vim";
        rev = "49dc50348df20cc54628b4599d0ce89bd07213e5";
        hash = "sha256-M5Tx3iqCTqUxwuw7bbyJKI3sHHanZYvDrZ3r0p+LRl4=";
      };
    })
    (pkgs.vimUtils.buildVimPlugin {
      name = "jupyter-vim";
      src = pkgs.fetchFromGitHub {
        owner = "jupyter-vim";
        repo = "jupyter-vim";
        rev = "91eef96d0f26ce37db241833341d08d11c8e5215";
        hash = "sha256-p00O3YYbMz5ekx8O9kkX+TLNgNdnR427Zr39t17OfrU=";
      };
    })
  ];

  plugins = {
    web-devicons.enable = true;
    barbecue.enable = true;
    gitsigns.enable = true;
    rainbow-delimiters.enable = true;
    coverage.enable = true;
    # Error occurred for autocommand FTplugin
    # quarto = {
    #   enable = true;
    #   settings = {
    #     lspFeatures = {
    #       enabled = true;
    #       # With "julia" autocmd error occurred.
    #       languages = [ "r" "python" "bash" "html" ];
    #       completion.enabled = true;
    #       diagnostics.enabled = true;
    #     };
    #   };
    # };

    # Not work
    # efmls-configs = {
    #   enable = true;
    #   setup = {
    #     tex = {
    #       formatter = [ "latexindent" ];
    #       linter = [ "vale" ];
    #     };
    #   };
    # };

    toggleterm = {
      enable = true;
      settings = {
        open_mapping = "[[<c-\\>]]";
        direction = "float";
        float_opts = {
          border = "curved";
          height = 30;
          width = 130;
        };
      };
    };

    vimtex = {
      enable = true;
      settings = {
        compiler_method = "latexrun";
        toc_config = {
          split_pos =
            "\n              vert\n              topleft\n              ";
          split_width = 40;
        };
        view_method = "zathura";
        imaps_leader = "¬";
      };
    };
  };
}
