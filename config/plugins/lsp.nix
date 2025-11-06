{ pkgs, ... }:
let
  inherit (pkgs.lib) getExe;
  # julia = getExe pkgs.julia-bin;
  alejandra = getExe pkgs.alejandra;
in {
  plugins.lsp = {
    enable = true;
    servers = {
      lua_ls = {
        enable = true;
        settings.format.enable = true;
      };
      rust_analyzer = {
        enable = true;
        installRustc = true;
        installCargo = true;
      };
      nixd = {
        enable = true;
        package = pkgs.nixd;
        settings = {
          nixpkgs = { expr = "import <nixpkgs> { }"; };
          formatting.command = [ "${alejandra}" ];
        };
      };
      clangd = {
        enable = true;
        cmd = [ "clangd" "--offset-encoding=utf-16" ];
      };
      cmake.enable = true;
      bashls.enable = true;
      dockerls.enable = true;
      r_language_server = {
        enable = true;
        package = null;
        cmd = [ "R" "--slave" "-e" "languageserver::run()" ];
        filetypes = [ "r" "rmd" ];
      };
      julials = {
        enable = true;
        # cmd = [
        #   "julia"
        #   "--startup-file=no"
        #   "--history-file=no"
        #   "--project=~/.julia/environment/nvim-lspconfig"
        #   "-e"
        #   ''
        #     import Pkg; Pkg.add("LanguageServer"); using LanguageServer; runserver()''
        # ];
        cmd = [
          "nix"
          "develop"
          ".#\${DEVSHELL_NAME}"
          "--command"
          "julia"
          "--startup-file=no"
          "--history-file=no"
          "--project=~/.julia/environment/nvim-lspconfig"
          "-e"
          "using LanguageServer; runserver()"
        ];
        # rootDir = # lua
        #   ''
        #     function(fname)
        #       return lspconfig.util.find_git_ancestor(fname) or vim.loop.os_homedir()
        #     end
        #   '';
        package = pkgs.julia-bin;
      };
      pyright.enable = true;
      # pylyzer.enable = true;
      # Generated many error logs in ~/.local/state/nvim/lsp.log
      # ltex.enable = true;
      texlab = {
        enable = true;
        filetypes = [ "tex" ];
      };
    };

    keymaps.lspBuf = {
      K = "hover";
      gD = "references";
      gd = "definition";
      gi = "implementation";
      gt = "type_definition";
    };
  };
}
