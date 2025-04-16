{
  plugins = {
    luasnip = {
      enable = true;
      fromLua = [{ paths = ./LuaSnip; }];
      settings = {
        history = true;
        # Enable autotriggered snippets
        enable_autosnippets = true;
        # Use Tab (or some other key if you prefer) to trigger visual selection
        store_selection_keys = "<C-f>";
        # Update text as you type for repeat node
        update_events = "TextChanged,TextChangedI";
      };
      luaConfig.pre =
        # lua
        ''
          require("luasnip").config.set_config({ -- Setting LuaSnip config
          	ext_opts = {
          		[require("luasnip.util.types").choiceNode] = {
          			active = {
          				virt_text = { { "➜", "GruvboxOrange" } },
          			},
          		},
          	},
          })
        '';
    };
  };

  keymaps = [
    {
      key = "<C-f>";
      mode = [ "i" "s" ];
      action.__raw =
        # lua
        ''
          function()
            if require("luasnip").expand_or_jumpable() then
              require("luasnip").expand()
            end
          end
        '';
    }
    {
      key = "<C-j>";
      mode = [ "i" "s" ];
      action.__raw =
        # lua
        ''
          function()
            if require("luasnip").jumpable(1) then
              require("luasnip").jump(1)
            end
          end
        '';
    }
    {
      key = "<C-k>";
      mode = [ "i" "s" ];
      action.__raw =
        # lua
        ''
          function()
            if require("luasnip").jumpable(-1) then
              require("luasnip").jump(-1)
            end
          end
        '';
    }
    {
      key = "<C-l>";
      mode = [ "i" "s" ];
      action.__raw =
        # lua
        ''
          function()
            if require("luasnip").choice_active() then
              require("luasnip").change_choice(1)
            end
          end
        '';
    }
    {
      key = "<C-h>";
      mode = [ "i" "s" ];
      action.__raw =
        # lua
        ''
          function()
            if require("luasnip").choice_active() then
              require("luasnip").change_choice(-1)
            end
          end
        '';
    }
    {
      key = "<Leader>o";
      mode = [ "n" ];
      action = ''
        <Cmd>lua require("luasnip.loaders.from_lua").load({paths = "${
          ./LuaSnip
        }"})<CR>'
      '';
    }
  ];
}
