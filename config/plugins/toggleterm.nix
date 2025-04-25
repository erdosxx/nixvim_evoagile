{ pkgs, ... }:
let
  inherit (pkgs.lib) getExe;
  lazygit = getExe pkgs.lazygit;
  htop = getExe pkgs.htop;
  python = getExe pkgs.python3;
  ncdu = getExe pkgs.ncdu;
  R = getExe pkgs.R;
in {
  plugins.which-key = {
    settings.spec = [
      {
        __unkeyed-1 = "<leader>tg";
        __unkeyed-2 = "<cmd>lua _LAZYGIT_TOGGLE()<CR>";
        desc = "Lazygit";
        nowait = true;
        remap = false;
      }
      {
        __unkeyed-1 = "<leader>tj";
        __unkeyed-2 = "<cmd>lua _JULIA_TOGGLE()<cr>";
        desc = "Julia";
        nowait = true;
        remap = false;
      }
      {
        __unkeyed-1 = "<leader>tp";
        __unkeyed-2 = "<cmd>lua _PYTHON_TOGGLE()<cr>";
        desc = "Python";
        nowait = true;
        remap = false;
      }
      {
        __unkeyed-1 = "<leader>tt";
        __unkeyed-2 = "<cmd>lua _HTOP_TOGGLE()<cr>";
        desc = "Htop";
        nowait = true;
        remap = false;
      }
      {
        __unkeyed-1 = "<leader>tu";
        __unkeyed-2 = "<cmd>lua _NCDU_TOGGLE()<cr>";
        desc = "NCDU";
        nowait = true;
        remap = false;
      }
      {
        __unkeyed-1 = "<leader>tr";
        __unkeyed-2 = "<cmd>lua _R_TOGGLE()<cr>";
        desc = "R";
        nowait = true;
        remap = false;
      }
    ];
  };

  plugins.toggleterm = {
    enable = true;
    settings = {
      size = ''
        function(term)
          if term.direction == "horizontal" then
            return 20
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.382
          end
        end
      '';
      open_mapping = "[[<c-\\>]]";
      hide_numbers = true;
      shade_filetypes = [ ];
      shade_terminals = true;
      shading_factor = 2;
      start_in_insert = true;
      insert_mappings = true;
      persist_size = true;
      direction = "float";
      close_on_exit = true;
      shell = { __raw = "vim.o.shell"; };
      float_opts = {
        border = "curved";
        winblend = 0;
        highlights = {
          border = "Normal";
          background = "Normal";
        };
      };
    };

    luaConfig.pre = ''
      local status_ok, toggleterm = pcall(require, "toggleterm")
      if not status_ok then
      	return
      end

      function Set_terminal_keymaps()
        local opts = {noremap = true}
        -- vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
        -- vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
      end

      vim.cmd('autocmd! TermOpen term://* lua Set_terminal_keymaps()')

      local Terminal = require("toggleterm.terminal").Terminal

      local lazygit = Terminal:new({ cmd = "${lazygit}", hidden = true, direction = "float" })
      function _LAZYGIT_TOGGLE()
      	lazygit:toggle()
      end

      local julia = Terminal:new({ cmd = "nix develop --command julia --project=.", hidden = true, direction = "vertical" })
      function _JULIA_TOGGLE()
      	julia:toggle()
      end

      local ncdu = Terminal:new({ cmd = "${ncdu}", hidden = true, direction = "float" })
      function _NCDU_TOGGLE()
      	ncdu:toggle()
      end

      local htop = Terminal:new({ cmd = "${htop}", hidden = true, direction = "float" })
      function _HTOP_TOGGLE()
      	htop:toggle()
      end

      local python = Terminal:new({ cmd = "${python}", hidden = true, direction = "vertical" })
      function _PYTHON_TOGGLE()
      	python:toggle()
      end

      local R = Terminal:new({ cmd = "${R}", hidden = true, direction = "vertical" })
      function _R_TOGGLE()
      	R:toggle()
      end
    '';
  };
}
