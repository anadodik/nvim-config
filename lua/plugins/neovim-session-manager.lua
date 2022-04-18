require"session_manager".setup({
  autoload_mode = require("session_manager.config").AutoloadMode.Disabled, -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
  max_path_length = 88,  -- Shorten the display path if length exceeds this threshold. Use 0 if don"t want to shorten the path at all.
})
