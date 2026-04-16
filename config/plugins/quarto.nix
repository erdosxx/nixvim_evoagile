{
  # Error occurred for autocommand FTplugin
  quarto = {
    enable = true;
    settings = {
      lspFeatures = {
        enabled = true;
        # With "julia" autocmd error occurred.
        languages = [
          "r"
          "python"
          "bash"
          "html"
        ];
        completion.enabled = true;
        diagnostics.enabled = true;
      };
    };
  };
}
