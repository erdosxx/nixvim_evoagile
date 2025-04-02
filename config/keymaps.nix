{
  keymaps = [
    {
      mode = "i";
      key = "jk";
      action = "<ESC>";
    }
    {
      mode = "i";
      key = "kj";
      action = "<ESC>";
    }
    {
      mode = "n";
      key = "<localleader>f";
      action = ":Format<cr>";
      options.silent = true;
    }
    {
      mode = "n";
      key = "gl";
      action = "<cmd>lua vim.diagnostic.open_float()<CR>";
      options.silent = true;
    }
    {
      mode = "n";
      key = "]d";
      action = ''<cmd>lua vim.diagnostic.goto_next({ border="rounded" })<CR>'';
      options.silent = true;
    }
    {
      mode = "n";
      key = "[d";
      action = ''<cmd>lua vim.diagnostic.goto_prev({ border="rounded" })<CR>'';
      options.silent = true;
    }
    {
      mode = "n";
      key = "<localleader>v";
      action = "<cmd>bdelete!<cr>";
    }
    {
      mode = "n";
      key = "<localleader>0";
      action = ":bnext<CR>";
    }
    {
      mode = "n";
      key = "<localleader>7";
      action = ":bprevious<CR>";
    }
    {
      mode = "n";
      key = "<C-t>";
      action = "<cmd>Telescope live_grep<CR>";
    }
    {
      mode = "n";
      key = "<C-s>";
      action = "<cmd>Telescope find_files<CR>";
    }
    {
      mode = "n";
      key = "<C-b>";
      action = "<cmd>Telescope buffers<CR>";
    }
    {
      mode = "n";
      key = "<leader>e";
      action = "<cmd>NvimTreeToggle<CR>";
    }
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
    }
    {
      mode = "n";
      key = "<localleader>m";
      action = ''
        <cmd>lua require("harpoon.mark").add_file() vim.notify("󱡅  marked file")<cr>'';
    }
    {
      mode = "i";
      key = "<F2>";
      action = "<ESC>i<C-j>";
      options = {
        desc = ''
          When cmp give choices, abort it and move
                    forward to next input for snippet.'';
        remap = true;
        silent = false;
      };
    }
    {
      mode = "i";
      key = "<F3>";
      action = "<ESC>xa";
      options = {
        desc = "remove comment string and add normal input for coding.";
        remap = true;
        silent = false;
      };
    }
    {
      # https://castel.dev/post/lecture-notes-1/
      mode = "i";
      key = "<C-y>";
      action = "<C-g>u<ESC>[s1z=`]a<C-g>u";
      options = {
        desc = "Auto correction for spelling with first suggestion.";
        noremap = true;
        silent = true;
      };
    }
  ];

  files = {
    "ftplugin/julia.lua" = {
      # extraConfigLua = /*lua*/''
      #     vim.api.nvim_create_autocmd("FileType", {
      #     pattern = "julia",
      #     callback = function()
      #       vim.opt_local.matchpairs:append("<:>")
      #       vim.b.match_words = [[\<function\>:\<end\>,\<if\>:\<elseif\>:\<else\>:\<end\>,\<do\>:\<end\>,\<begin\>:\<end\>,\<try\>:\<catch\>:\<finally\>:\<end\>,\<while\>:\<end\>,\<for\>:\<end\>,\<let\>:\<end\>,\<macro\>:\<end\>,\<module\>:\<end\>]]
      #     end,
      #   }) 
      # '';
      keymaps = [
        {
          mode = "n";
          key = "<localleader>o";
          action = "<CMD>!JuliaREPLConnect 2345<CR>";
          options = {
            silent = true;
            noremap = true;
          };
        }
        {
          mode = "n";
          key = "<localleader>u";
          action = "<CMD>!JuliaREPLSend<CR>";
          options = {
            silent = true;
            noremap = true;
          };
        }
        {
          mode = "v";
          key = "<localleader>u";
          action = ":!JuliaREPLSend<CR>";
          options = {
            silent = true;
            noremap = true;
          };
        }
        {
          mode = "v";
          key = "<localleader>k";
          action = ":!JuliaREPLSendRegion<CR> <cmd>normal! `><CR>";
          options = {
            silent = true;
            noremap = true;
          };
        }
        {
          mode = "n";
          key = "<localleader>/";
          action = "%:Format<CR>v%:!JuliaREPLSend<CR>%$";
          options = {
            silent = true;
            remap = true;
          };
        }
      ];
    };

    "ftplugin/python.lua" = {
      keymaps = [
        {
          mode = "n";
          key = "<localleader>o";
          action = ''
            <CMD>let g:python3_host_prog = substitute(system("which python3"), "\n", "", "")<CR><CMD>JupyterConnect<CR>'';
          options = {
            silent = true;
            noremap = true;
          };
        }
        {
          mode = "n";
          key = "<localleader>u";
          action = "<cmd>JupyterSendRange<CR>";
          options = {
            silent = true;
            noremap = true;
          };
        }
        {
          mode = "v";
          key = "<localleader>u";
          action =
            "V<cmd>normal! <Plug>JupyterRunVisual<CR> <cmd>normal! `><CR><ESC>";
          options = {
            silent = true;
            noremap = true;
          };
        }
        {
          mode = "v";
          key = "<localleader>k";
          action = "<Plug>JupyterRunVisual<CR> <cmd>normal! `><CR>";
          options = {
            silent = true;
            noremap = true;
          };
        }
        {
          mode = "n";
          key = "<localleader>/";
          action =
            "[m:Format<CR>]MV[m:JupyterSendRange<CR> <cmd>normal! `><CR>";
          options = {
            silent = true;
            remap = true;
          };
        }
        {
          mode = "n";
          key = "<localleader>.";
          action = "%:Format<CR>v%:JupyterSendRange<CR>%$";
          options = {
            silent = true;
            remap = true;
            desc = "format and send range for matching range by %";
          };
        }
      ];
    };

    "ftplugin/clojure.lua" = {
      keymaps = [
        {
          mode = "n"; # Visual mode
          key = "<localleader>o"; # Use '\b' as the shortcut
          action = "<cmd>ConjureCljRefreshAll<cr>";
          options = {
            silent = true;
            noremap = true;
          };
        }
        {
          mode = "n"; # Visual mode
          key = "<localleader>r"; # Use '\b' as the shortcut
          action = "<cmd>ConjureCljRefreshChanged<cr>";
          options = {
            silent = true;
            noremap = true;
          };
        }
      ];
    };
    "ftplugin/tex.lua" = {
      extraConfigLua =
        "\n          vim.cmd([[\n            :setlocal spell spelllang=en_us,en_gb\n          ]])\n        ";
    };
    "ftplugin/bib.lua" = {
      extraConfigLua =
        "\n          vim.cmd([[\n            :setlocal spell spelllang=en_us,en_gb\n          ]])\n        ";
      keymaps = [
        {
          mode = "v"; # Visual mode
          key = "<localleader>bf"; # Use '\b' as the shortcut
          action = ''c\btxIdxBf{<C-r>"}<Esc>'';
          options = {
            silent = true;
            noremap = true;
            desc = "Wrap selection with \\btxIdxBf{}";
          };
        }
        {
          mode = "v"; # Visual mode
          key = "<localleader>bn"; # Use '\b' as the shortcut
          action = ''c\btxIdxBfn{<C-r>"}{}<Left>'';
          options = {
            silent = true;
            desc = "Wrap selection with \\btxIdxBfn{}{} and place cursor";
          };
        }
        {
          mode = "v"; # Visual mode
          key = "<localleader>cs"; # Use '\b' as the shortcut
          action = ''c\csword{<C-r>"}<Esc>'';
          options = {
            silent = true;
            noremap = true;
            desc = "Wrap selection with \\csword{}";
          };
        }
        {
          mode = "v"; # Visual mode
          key = "<localleader>cd"; # Use '\b' as the shortcut
          action = ''c\cword{<C-r>"}{}<Left>'';
          options = {
            silent = true;
            desc = "Wrap selection with \\cword{}{} and place cursor";
          };
        }
        {
          mode = "v"; # Visual mode
          key = "<localleader>di"; # Use '\b' as the shortcut
          action = ''c{\dIdm <C-r>"}<Esc>'';
          options = {
            silent = true;
            noremap = true;
            desc = "Wrap selection with {\\dIdm }";
          };
        }
        {
          mode = "v"; # Visual mode
          key = "<localleader>qq"; # Use '\b' as the shortcut
          action = ''c\quotation{<C-r>"}<Esc>'';
          options = {
            silent = true;
            noremap = true;
            desc = "Wrap selection with \\quotation{}";
          };
        }
        {
          mode = "v"; # Visual mode
          key = "<localleader>qs"; # Use '\b' as the shortcut
          action = ''c\quote{<C-r>"}<Esc>'';
          options = {
            silent = true;
            noremap = true;
            desc = "Wrap selection with \\quote{}";
          };
        }
      ];
    };
  };
}
