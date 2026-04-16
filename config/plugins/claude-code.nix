{
  plugins.claude-code = {
    enable = true;
    settings = {
      window = {
        hide_numbers = false;
        hide_signcolumn = false;
        position = "vertical";
        split_ratio = 0.4;
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
    {
      mode = "v";
      key = "<localleader>c";
      action =
        ''<cmd>ClaudeCodeSend<cr>'';
      options = {
        desc = "Send current visual selection to Claude";
        noremap = true;
        silent = true;
      };
    }
  ];
}
