local cmp = require'cmp'
local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup {
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  filetype = {
    python = {
      require("formatter.filetypes.python").isort,
      function()
        return {
          exe = "black",
          args = { "--line-length", "88", "--target-version", "py38", "--stdin-filename", vim.api.nvim_buf_get_name(0), "-" },
          stdin = true
        }
      end
      -- require("formatter.filetypes.python").black,
    }
  }
}

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    -- ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
    -- ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
			-- if cmp.visible() then
			-- 	cmp.select_next_item()
      -- elseif luasnip.expand_or_jumpable() then
			-- 	luasnip.expand_or_jump()
			-- else
			-- 	fallback()
			-- end
		end, {"i", "s"}),

		["<S-Tab>"] = cmp.mapping(function(fallback)
      cmp_ultisnips_mappings.jump_backwards(fallback)
			-- if cmp.visible() then
			-- 	cmp.select_prev_item()
      -- elseif luasnip.jumpable(-1) then
			-- 	luasnip.jump(-1)
			-- else
			-- 	fallback()
			-- end
		end, {"i", "s"}),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require("lspconfig").pyright.setup {
  handlers = handlers,
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    client.server_capabilities.completionProvider = false
    client.server_capabilities.hoverProvider = false
    client.server_capabilities.definitionProvider = false
    client.server_capabilities.rename = false
    client.server_capabilities.renameProvider = false
    client.server_capabilities.signature_help = false
  end,
  filetypes = { "python" },
  settings = {
        python = {
            analysis = {
                typeCheckingMode = "off",
            },
        },
    }
}

require("lspconfig").jedi_language_server.setup {
  handlers = handlers,
  capabilities = capabilities,
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- delay update diagnostics
    update_in_insert = false,
  }
)

vim.diagnostic.config({
  --virtual_text = false,
  virtual_text = {
    severity=vim.diagnostic.severity.WARN,
  },
  signs = {
    severity=vim.diagnostic.severity.WARN,
  },
  severity_sort = true,
  underline = false,
})

require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'auto',
    component_separators = { left = ' ', right = ' '},
    section_separators = { left = ' ', right = ' '},
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = false,
  },
  sections = {

    lualine_a = {'mode'},
    lualine_b = {
      {
        'filename',
        file_status = true, -- displays file status (readonly status, modified status)
        path = 2 -- 0 = just filename, 1 = relative path, 2 = absolute path
      }
    },
    lualine_c = {'branch', 'diff', 'diagnostics'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {},
  tabline = {},
  extensions = {}
}


vim.api.nvim_create_user_command('CustomRename', function()
	vim.lsp.buf.rename()
end, {})


require("catppuccin").setup {
    color_overrides = {
        latte = {
            base = "#edeeee",
        },
        mocha = {
            base = "#262626",
        },
    },
    custom_highlights = function(colors)
        return {
            -- Change the color of the concealed math symbols
            Conceal = { fg = colors.peach, bg = colors.base },

            -- Optional: Adjust vimtex math zones if desired
            texMathZoneX = { fg = colors.peach, bg = colors.base },
            texMathZoneA = { fg = colors.lavender, bg = colors.base },
            texMathZoneB = { fg = colors.sky, bg = colors.base },
            texMathDelim = { fg = colors.red, bg = colors.base },
            texMathOper = { fg = colors.yellow, bg = colors.base },
        }
    end
}

-- require("codecompanion").setup({
--   adapters = {
--     openai = function()
--       return require("codecompanion.adapters").extend("openai", {
--         schema = {
--           model = {
--             default = "gpt-4o",
--           },
--         },
--         env = {
--           api_key = "",
--         },
--       })
--     end,
--   },
--   display = {
--     chat = {
--       -- Options to customize the UI of the chat buffer
--       window = {
--         layout = "vertical", -- float|vertical|horizontal|buffer
--         position = "right", -- left|right|top|bottom (nil will default depending on vim.opt.plitright|vim.opt.splitbelow)
--       },
--     },
--     diff = {
--       enabled = true,
--       close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
--       layout = "vertical", -- vertical|horizontal split for default provider
--       opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
--       provider = "default", -- default|mini_diff
--     },
--   },
--   strategies = {
--     chat = {
--       adapter = "openai",
--       keymaps = {
--         send = {
--           modes = { n = "<C-s>", i = "<C-s>" },
--         },
--         close = {
--           modes = { n = "<Esc>", i = "<Esc>" },
--         },
--         -- Add further custom keymaps here
--       },
--     },
--     inline = {
--       adapter = "openai",
--       keymaps = {
--         accept_change = {
--           modes = { n = "ga" },
--           description = "Accept the suggested change",
--         },
--         reject_change = {
--           modes = { n = "gr" },
--           description = "Reject the suggested change",
--         },
--       },
--     },
--   },
-- })
-- 
-- vim.api.nvim_set_keymap("v", "ge", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
