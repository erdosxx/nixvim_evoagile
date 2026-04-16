{
  plugins.claude-code = {
    enable = true;
    settings = {
      window = {
        hide_numbers = false;
        hide_signcolumn = false;
        position = "vertical";
        split_ratio = 0.3;
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<localleader>c";
      action =
        ''<cmd>ClaudeCode<cr>'';
      options = {
        desc = "Toggle the Claude Code terminal window";
        noremap = true;
        silent = true;
      };
    }
    { # Not work: Cannot find ClaudeCodeSend command.
      mode = "v";
      key = "<localleader>c";
      action =
        '':<C-u>ClaudeCodeSend<cr>'';
      options = {
        desc = "Send current visual selection to Claude";
        noremap = true;
        silent = true;
      };
    }
  ];
}
