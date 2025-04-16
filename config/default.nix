{ pkgs, nixpkgs-unfree, ... }:
let
  inherit (pkgs.lib) getExe;
  julia = getExe pkgs.julia-bin;
  alejandra = getExe pkgs.alejandra;
in {
  imports = [
    ./plugins/alpha.nix
    ./plugins/bufferline.nix
    ./plugins/illuminate.nix
    ./plugins/lsp.nix
    ./plugins/luasnip.nix
    ./plugins/navic.nix
    ./plugins/none-ls.nix
    ./plugins/nvim-tree.nix
    ./plugins/telescope-harpoon.nix
    ./plugins/treesitter.nix
    ./plugins/whichkey.nix
    ./options.nix
    ./keymaps.nix
    (import ./cmp.nix { inherit nixpkgs-unfree; })
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

  autoCmd = [
    {
      desc = "Save last cusor position for reopen it with same position";
      event = "BufReadPost";

      callback.__raw =
        # lua
        ''
          function()
            local mark = vim.api.nvim_buf_get_mark(0, '"')
            local lcount = vim.api.nvim_buf_line_count(0)
            if mark[1] > 0 and mark[1] <= lcount then
              pcall(vim.api.nvim_win_set_cursor, 0, mark)
            end
          end
        '';
    }
    {
      desc = "Auto close nvim tree";
      event = "BufEnter";

      callback.__raw =
        # lua
        ''
          function()
            local function is_modified_buffer_open(buffers)
              for _, v in pairs(buffers) do
                  if v.name:match("NvimTree_") == nil then
                      return true
                  end
              end
              return false
            end

            if #vim.api.nvim_list_wins() == 1
              and vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil
              and is_modified_buffer_open(vim.fn.getbufinfo({ bufmodified = 1 })) == false
            then
              vim.cmd("quit")
            end
          end
        '';
    }
    {
      desc = "Define markdown filetype for calcurse";
      event = [ "BufRead" "BufNewFile" ];
      pattern = "/tmp/calcurse*";

      callback.__raw =
        # lua
        ''
          function()
            vim.bo.filetype = "markdown"
          end
        '';
    }
    {
      desc = "Define markdown filetype for calcurse";
      event = [ "BufRead" "BufNewFile" ];
      pattern = "~/localgit/myCalcurse/notes/*";

      callback.__raw =
        # lua
        ''
          function()
            vim.bo.filetype = "markdown"
          end
        '';
    }
  ];

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
    lualine.enable = true;
    comment.enable = true;
    nvim-autopairs.enable = true;
    gitsigns.enable = true;
    rainbow-delimiters.enable = true;
    coverage.enable = true;
    indent-blankline.enable = true;
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
