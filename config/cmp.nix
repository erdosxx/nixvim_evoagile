{
  plugins = {
    cmp-buffer.enable = true;
    cmp-path.enable = true;
    cmp-cmdline.enable = true;
    cmp_luasnip.enable = true;
    cmp-nvim-lsp.enable = true;
    cmp-nvim-lua.enable = true;

    cmp = {
      enable = true;
      autoEnableSources = true;

      filetype = {
        tex = {
          sources = [
            {name = "luasnip";}
            {name = "nvim_lsp";}
          ];
        };
      };

      settings = {
        snippet.exapnd = ''
          function(args)
            require('luasnip').lsp_expand(args.body)
          end
        '';
        experimental = {
          ghost_text = false;
          native_menu = false;
        };
        mapping = {
          "<C-k>" = "cmp.mapping.select_prev_item()";
          "<C-j>" = "cmp.mapping.select_next_item()";
          "<C-b>" = ''cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" })'';
          "<C-f>" = ''cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" })'';
          "<C-Space>" = ''cmp.mapping(cmp.mapping.complete(), { "i", "c" })'';
          "<C-y>" = "cmp.config.disable";
          "<C-e>" = ''
            cmp.mapping({
              i = cmp.mapping.abort(),
              c = cmp.mapping.close(),
            })'';
          "<CR>" = ''
            cmp.mapping.confirm ({
              behavior = cmp.ConfirmBehavior.Replace,
              select = false,
            })'';
          "<Tab>" = ''
            cmp.mapping(
              function(fallback)
                local snip_status_ok, luasnip = pcall(require, "luasnip")
                if not snip_status_ok then
            	    return
                end

                local check_backspace = function()
                  local col = vim.fn.col(".") - 1
                  return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
                  end

                local has_words_before = function()
            	    if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then
            		    return false
            	    end
            	    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            	    return col ~= 0
            		    and vim.api
            		      .nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]
            		      :match("^%s*$")
            		    == nil
                end

               	if cmp.visible() and has_words_before() then
                	cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
               	elseif luasnip.expandable() then
                	luasnip.expand()
               	elseif luasnip.expand_or_jumpable() then
                	luasnip.expand_or_jump()
               	elseif check_backspace() then
                	fallback()
               	else
                	fallback()
               	end
              end, { "i", "s", })
          '';
          "<S-Tab>" = ''
            cmp.mapping(
              function(fallback)
                local snip_status_ok, luasnip = pcall(require, "luasnip")
                if not snip_status_ok then
                  return
                end

            	  if cmp.visible() then
            		  cmp.select_prev_item()
            	  elseif luasnip.jumpable(-1) then
            		  luasnip.jump(-1)
            	  else
            		  fallback()
            	  end
              end, { "i", "s", })
          '';
        };
        formatting = {
          fields = [
            "kind"
            "abbr"
            "menu"
          ];
          format = ''
            function(entry, vim_item)
              local kind_icons = {
              	Text = "󰉿",
              	Method = "m",
              	Function = "󰊕",
              	Constructor = "",
              	Field = "",
              	Variable = "󰆧",
              	Class = "󰌗",
              	Interface = "",
              	Module = "",
              	Property = "",
              	Unit = "",
              	Value = "󰎠",
              	Enum = "",
              	Keyword = "",
              	Snippet = "",
              	Color = "󰏘",
              	File = "󰈙",
              	Reference = "",
              	Folder = "󰉋",
              	EnumMember = "",
              	Constant = "󰇽",
              	Struct = "",
              	Event = "",
              	Operator = "󰆕",
              	TypeParameter = "󰊄",
              	Copilot = "",
              }
              vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
              vim_item.menu = ({
                copilot = "[Copilot]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[NVIM_LUA]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
              })[entry.source.name]
              local maxwidth = 80
              vim_item.abbr = string.sub(vim_item.abbr, 1, maxwidth)
              return vim_item
            end
          '';
        };
        sources = [
          {name = "copilot";}
          {name = "nvim_lsp";}
          {name = "nvim_lua";}
          {name = "luasnip";}
          {name = "buffer";}
          {name = "path";}
        ];
        window.documentation.border = [
          "╭"
          "─"
          "╮"
          "│"
          "╯"
          "─"
          "╰"
          "│"
        ];
      };
    };
  };
}
