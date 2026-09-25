{
  pkgs,
  ...
}: let
  inherit (pkgs.lib) getExe;
  # julia = getExe pkgs.julia-bin;
  alejandra = getExe pkgs.alejandra;
in {
  plugins.lsp = {
    enable = true;
    servers = {
      clojure_lsp.enable = true;
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
          nixpkgs = {
            expr = "import <nixpkgs> { }";
          };
          formatting.command = ["${alejandra}"];
        };
      };
      clangd = {
        enable = true;
        cmd = [
          "clangd"
          "--offset-encoding=utf-16"
        ];
      };
      r_language_server = {
        enable = true;
        package = null;
        cmd = [
          "R"
          "--slave"
          "-e"
          "languageserver::run()"
        ];
        filetypes = [
          "r"
          "rmd"
        ];
      };
      julials = let
        juliaLsp = pkgs.writeShellScriptBin "julia-lsp" ''
          set -eu

          project_root="''${JULIA_PROJECT_ROOT:-$PWD}"
          language_server_project="$project_root/.julia-depot/environments/language-server"

          exec ${pkgs.julia-bin}/bin/julia \
            --startup-file=no \
            --history-file=no \
            --project="$language_server_project" \
            -e 'using LanguageServer; runserver()'
        '';
      in {
        enable = true;
        cmd = [
          "${juliaLsp}/bin/julia-lsp"
        ];
        # cmd = let devshellName = builtins.getEnv "DEVSHELL_NAME";
        # in [
        #   "nix"
        #   "develop"
        #   (".#" + devshellName)
        #   "--command"
        #   "julia"
        #   "--startup-file=no"
        #   "--history-file=no"
        #   "--project=~/.julia/environment/nvim-lspconfig"
        #   "-e"
        #   "using LanguageServer; runserver()"
        # ];
        # rootDir = # lua
        #   ''
        #     function(fname)
        #       return lspconfig.util.find_git_ancestor(fname) or vim.loop.os_homedir()
        #     end
        #   '';
        package = pkgs.julia-bin;
      };
      texlab = {
        enable = true;
        filetypes = ["tex"];
      };
      bashls.enable = true;
      cmake.enable = true;
      dockerls.enable = true;
      markdown_oxide.enable = true;
      pyright.enable = true;
      zls.enable = true;
    };

    keymaps.lspBuf = {
      K = "hover";
      gD = "references";
      gd = "definition";
      gi = "implementation";
      gt = "type_definition";
    };
  };

  extraConfigLua = ''
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "julia",
      callback = function(args)
        local project_root = vim.fs.root(args.buf, {
          "Project.toml",
          "JuliaProject.toml",
          ".git",
        }) or vim.fn.getcwd()

        vim.env.JULIA_PROJECT_ROOT = project_root
      end,
    })
  '';
}
