local M = {}

local whichkey = require "which-key"
local command_center = require("command_center")

local keymap = vim.api.nvim_set_keymap
local buf_keymap = vim.api.nvim_buf_set_keymap

local function keymappings(client, bufnr)
  local opts = { noremap = true, silent = true }

  -- Key mappings
  vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = true })
  vim.keymap.set("n", "[c", vim.diagnostic.goto_prev, {})
  vim.keymap.set("n", "]c", vim.diagnostic.goto_next, {})

  -- Whichkey
  local keymap_l = {
    l = {
      name = "Code",
      l = { "<cmd>Telescope command_center<CR>", "Command Center" },

      n = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },

      R = { "<cmd>Trouble lsp_references<CR>", "Trouble References" },
      r = { "<cmd>Telescope lsp_references theme=dropdown<CR>", "Search References" },

      d = { "<cmd>lua require('telescope.builtin').lsp_definitions({jump_type='never'})<CR>", "Search Definitions" },
      g = { "<Cmd>lua vim.lsp.buf.definition()<CR>", "Goto Definition" },
      s = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help" },

      -- a = { "<cmd>Telescope lsp_code_actions theme=dropdown<CR>", "Code Action" },
      -- D = { "<Cmd>lua vim.lsp.buf.declaration()<CR>", "Declaration" },
      -- I = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Goto Implementation" },
      -- t = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Goto Type Definition" },
    },
  }

  local whichkey_opts = { buffer = bufnr, prefix = "<leader>" }
  whichkey.register(keymap_l, whichkey_opts)

  command_center.add({
    {
      description = "Trouble Diagnostics",
      cmd = "<cmd>Trouble workspace_diagnostics<CR>",
    },
    {
      description = "Lsp Info",
      cmd = "<cmd>LspInfo<CR>",
    },
  })


  if client.resolved_capabilities.document_formatting then
    command_center.add({ cmd = "<cmd>lua vim.lsp.buf.formatting()<CR>", description = "Format Document" })
  end
end

function M.setup(client, bufnr)
  keymappings(client, bufnr)
end

return M
