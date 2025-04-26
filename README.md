# Nixvim Evolution - Modern Neovim Configuration Built with Nix

A modern Neovim configuration leveraging Nixvim for reproducible environment management. Originating from [LunarVim's Neovim-from-scratch](https://github.com/LunarVim/Neovim-from-scratch), this configuration adds Nix-powered dependency management and additional productivity enhancements.

_Add actual screenshot path later_

## ✨ Features

- **Nix-powered reproducibility** - Never break your editor with atomic updates
- **Batteries-included IDE experience**:
  - LSP support for 50+ languages
  - Smart code completion (nvim-cmp)
  - File tree explorer (Nvim-tree)
  - Git integration (gitsigns)
  - Modern UI components (telescope, which-key)
- **Easy customization** - Modify through Nix expressions, not Lua

## 🚀 Quick Start

### Prerequisites

- Neovim 0.9+
- Nix package manager
- [Nerd Font](https://www.nerdfonts.com/) (Recommended)

### Try Immediately

```bash
nix run github:erdosxx/nixvim_evoagile
```

## 📦 Installation

### Flakes Users (Recommended)

```nix
{
  inputs = {
    nixvim_evoagile.url = "github:erdosxx/nixvim_evoagile";
  };

  outputs = {nixvim_evoagile, ...}: {
    neovim = nixvim_evoagile.packages.x86_64-linux.default;
  };
}
```

### Classic Nix (Non-flakes)

```bash
nix-env -iA nixvim -f https://github.com/erdosxx/nixvim_evoagile/archive/main.tar.gz
```

## 🔧 Configuration

### Customize Your Setup

Override default settings in `flake.nix`:

```nix
{
  nixvim.overrides = {
    plugins = {
      telescope.enable = true;
      lualine.style = "stealth";
    };
    colorscheme = "catppuccin-mocha";
  };
}
```

### Key Features

| Category          | Plugins/Tools                                   |
| :---------------- | :---------------------------------------------- |
| Core              | Which-key                                       |
| UI Enhancements   | Telescope, Nvim-tree, Lualine                   |
| Code Intelligence | nvim-lspconfig, nvim-cmp, Treesitter            |
| Terminal          | Toggleterm with sending texts for julia, R, etc |

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📜 License

Distributed under the MIT License. See `LICENSE` for more information.

## 💬 Support

Found an issue? Please [open a ticket](https://github.com/erdosxx/nixvim_evoagile/issues).

---

<div style="text-align: center">⁂</div>

[^1]: https://github.com/nix-community/nixvim

[^2]: https://github.com/LunarVim/Neovim-from-scratch
