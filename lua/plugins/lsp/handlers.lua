local M = {}

function M.setup()
  -- LSP handlers configuration
  local lsp = {
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
    },
    diagnostic = {
      virtual_text = false,
      -- virtual_text = { spacing = 4, prefix = "⚡" },
      -- underline = true,
      update_in_insert = true,
      severity_sort = true,
      float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
      },
    },
    special_diagnostic = {
      virtual_text = true,
      -- virtual_text = { spacing = 4, prefix = "⚡" },
      -- underline = true,
      update_in_insert = true,
      severity_sort = true,
      float = {
        focusable = true,
        style = "minimal",
        border = "double",
      },
    }
  }

  -- Diagnostic signs
  local diagnostic_signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }
  for _, sign in ipairs(diagnostic_signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
  end

  local function open_diagnostic_float()
    local wins = vim.api.nvim_tabpage_list_wins(0)
    local float_wins = vim.tbl_filter(
      function(k)
        return vim.api.nvim_win_get_config(k).relative ~= ""
      end,
      wins
    )
    if #float_wins == 0 then
      vim.diagnostic.open_float(nil, {focus=false})
    end
  end

  vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
    callback = open_diagnostic_float,
  })

  -- Diagnostic configuration
  vim.diagnostic.config(lsp.diagnostic)

  -- Hover configuration
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, lsp.float)

  -- Signature help configuration
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, lsp.float)
end

return M
