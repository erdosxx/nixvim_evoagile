{pkgs}: {
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
}
