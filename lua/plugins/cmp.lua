local M = {}

function M.setup()
  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
  end

  -- local luasnip = require "luasnip"
  local cmp = require("cmp")
  local lspkind = require("lspkind")

  local format = lspkind.cmp_format({
    -- mode = 'symbol',
    menu = {
      buffer = "[Buffer]",
      path = "[Path]",
      nvim_lua = "[Lua]",
      treesitter = "[Treesitter]",
      nvim_lsp = "[LSP]",
      -- luasnip = "[Snip]",
    }
  })

  cmp.setup {
    completion = { completeopt = "menu,menuone,noinsert", keyword_length = 1 },
    experimental = { native_menu = false, ghost_text = true },
    -- snippet = {
    --   expand = function(args)
    --     require("luasnip").lsp_expand(args.body)
    --   end,
    -- },
    formatting = {
      format = format,
    },
    mapping = {
      ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      ["<C-e>"] = cmp.mapping { i = cmp.mapping.close(), c = cmp.mapping.close() },
      ["<CR>"] = cmp.mapping {
        i = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false },
        c = function(fallback)
          if cmp.visible() then
            cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
          else
            fallback()
          end
        end,
      },
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        -- elseif luasnip.expand_or_jumpable() then
        --   luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, {
        "i",
        "s",
        "c",
      }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        -- elseif luasnip.jumpable(-1) then
        --   luasnip.jump(-1)
        else
          fallback()
        end
      end, {
        "i",
        "s",
        "c",
      }),
    },
    sources = {
      { name = 'nvim_lsp', group_index = 1 },
      { name = "nvim_lua", group_index = 1 },
      { name = 'buffer', group_index = 2 },
      { name = 'treesitter', group_index = 2 },
      -- { name = "path", group_index = 2 },
      -- { name = "luasnip" },
      -- { name = "spell" },
      -- { name = "emoji" },
      -- { name = "calc" },
    },
    window = {
      documentation = {
        border = "rounded",
        winhighlight = 'FloatBorder:FloatBorder,Normal:Normal',
      },
      completion = {
        border = "rounded",
        winhighlight = 'FloatBorder:FloatBorder,Normal:Normal',
      }
    }
  }

  -- Use buffer source for `/`
  cmp.setup.cmdline("/", {
    sources = {
      { name = "buffer" },
    },
  })

  -- Use cmdline & path source for ':'
  -- cmp.setup.cmdline(":", {
  --   sources = cmp.config.sources({
  --     { name = "path" },
  --   }, {
  --     { name = "cmdline" },
  --   }),
  -- })

  -- Auto pairs
  -- local cmp_autopairs = require "nvim-autopairs.completion.cmp"
  -- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })
end

return M
