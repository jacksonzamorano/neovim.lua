# Neovim

## Structure

- `init.lua` loads the modules in startup order.
- `lua/config/options.lua` holds global editor options.
- `lua/config/keymaps.lua` holds general keymaps and floating-window workflows.
- `lua/config/core/ui.lua` provides shared modal, terminal, and window helpers.
- `lua/config/plugins/` configures plugin manager entries and plugin setup.
- `lua/config/lsp.lua` contains LSP servers, completion, and LSP keymaps.
- `lua/config/formatting.lua` contains format-on-command behavior.
- `lua/config/features/` contains focused editor features and commands.
- `lua/arduino.lua` contains the Arduino integration.
