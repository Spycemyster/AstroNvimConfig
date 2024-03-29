return {
  -- Configure AstroNvim updates
  updater = {
    remote = "origin", -- remote to use
    channel = "stable", -- "stable" or "nightly"
    version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "nightly", -- branch name (NIGHTLY ONLY)
    commit = nil, -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false, -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    auto_quit = false, -- automatically quit the current session after a successful update
    remotes = { -- easily add new remotes to track
      --   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
      --   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
      --   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
    },
  },

  -- Set colorscheme to use
  colorscheme = "astrodark",

  -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
  diagnostics = {
    virtual_text = true,
    underline = true,
  },

  lsp = {
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = false, -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "cs",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        -- "lua_ls",
      },
      timeout_ms = 3000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- enable servers that you already have installed without mason
    servers = {
      -- "pyright"
    },
  },

  -- Configure require("lazy").setup() options
  lazy = {
    defaults = { lazy = true },
    performance = {
      rtp = {
        -- customize default disabled vim plugins
        disabled_plugins = { "tohtml", "gzip", "matchit", "zipPlugin", "netrwPlugin", "tarPlugin" },
      },
    },
  },

  -- This function is run last and is a good place to configuring
  -- augroups/autocommands and custom filetypes also this just pure lua so
  -- anything that doesn't fit in the normal config locations above can go here
  polish = function()
    -- vim.api.nvim_set_keymap('l', '<leader>lF', ':NeoFormat<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', '<Leader>lk', function()
      vim.lsp.buf.hover()
    end, { silent = true, noremap = true, desc = 'Hover current symbol' })
    -- vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', { silent = true, noremap = true, desc = 'Go to Definition'})
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', { silent = true, noremap = true, desc = 'Go to Declaration'})
    vim.keymap.set('n', '<Leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', { silent = true, noremap = true, desc = 'Code Action'})
    -- vim.keymap.set('n', '<Leader>lg', '<cmd>Telescope lsp_definitions<cr>', { silent = true, noremap = true, desc = 'Go to Definition'})
    vim.keymap.set("n", "<Leader>lg", "<Cmd>lua require('dotnet-goto').lsp_request_definition()<CR>", { noremap = false, silent = true, desc="Go to Definition (dotnet)" })
    vim.keymap.set('n', '<Leader>fe', '<cmd>Telescope find_files hidden=true<cr>', { silent = true, noremap = true, desc = 'Find Hidden Files'})
    vim.keymap.set('n', 'gpd', '<cmd>lua require("goto-preview").goto_preview_definition()<cr>', { silent = true, noremap = true, desc = 'Go to Preview Definition'})
    vim.keymap.set('n', 'gpt', '<cmd>lua require("goto-preview").goto_preview_type_definition()<cr>', { silent = true, noremap = true, desc = 'Go to Preview Type Definition'})
    vim.keymap.set('n', 'gpi', '<cmd>lua require("goto-preview").goto_preview_implementation()<cr>', { silent = true, noremap = true, desc = 'Go to Preview Implementation'})
    vim.keymap.set('n', 'gpD', '<cmd>lua require("goto-preview").goto_preview_declaration()<cr>', { silent = true, noremap = true, desc = 'Go to Preview Declaration'})
    vim.keymap.set('n', 'gpr', '<cmd>lua require("goto-preview").goto_preview_references()<cr>', { silent = true, noremap = true, desc = 'Go to Preview References'})
    vim.keymap.set('n', 'gP', '<cmd>lua require("goto-preview").close_all_win()<cr>', { silent = true, noremap = true, desc = 'Close All Windows'})
    vim.g.editorconfig = true

    vim.opt.tabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.expandtab = true
    -- vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false, silent = true, noremap = true, desc = "Accept Copilot Suggestion"})
    -- vim.g.copilot_no_tab_map = true
    -- vim.g.copilot_assume_mapped = true
    local dap = require('dap')
    dap.adapters.coreclr = {
      type = 'executable',
      command = 'C:/Program Files/Netcoredbg/netcoredbg.exe',
      args = { '--interpreter=vscode'},
    }

    dap.configurations.cs = {
      {
        type = 'coreclr',
        name = 'launch - netcoredbg',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/', 'file')
        end,
      }
    }
    require('nvim-ts-autotag').setup()
    vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
        underline = true,
        virtual_text = {
            spacing = 5,
            severity_limit = 'Warning',
        },
        update_in_insert = true,
    })
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.offsetEncoding = 'utf-8'
    require('lspconfig').clangd.setup {
      capabilities = capabilities
    }
    local lspkind = require("lspkind")
    lspkind.init({
      symbol_map = {
        Copilot = "",
      },
    })

vim.api.nvim_set_hl(0, "CmpItemKindCopilot", {fg ="#6CC644"})
    local cmp = require("cmp")
    cmp.setup {
      sources = {
        { name = "copilot", group_index = 2 },
        { name = "nvim_lsp", group_index = 2 },
        { name = "path", group_index = 2 },
        { name = "luasnip", group_index = 2 },
      }
    }
    --[[
    local pid = vim.fn.getpid()
    local omnisharp_bin = "C:/Users/lalam/AppData/Local/omnisharp-vim/omnisharp-roslyn/OmniSharp.exe"
    local config = {
      handlers = {
        ["textDocument/definition"] = require("omnisharp_extended").handler,
      },
      cmd = { omnisharp_bin, '--languageserver', '--hostPID', tostring(pid) },
      capabilities = capabilities,
    }


    require'lspconfig'.omnisharp.setup(config)
    --]]

    -- vim.keymap.set('n', '<F10>', function() require('dap').step_out() end)
    -- vim.keymap.set('n', '<F9>', function() require('dap').step_into() end)
    -- vim.keymap.set('n', '<F8>', function() require('dap').step_over() end)
    -- vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
    -- vim.keymap.set('n', '<Leader>db', function() require('dap').toggle_breakpoint() end)
    -- vim.keymap.set('n', '<Leader>dB', function() require('dap').set_breakpoint() end)
    -- vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
    -- vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
    -- vim.keymap.set('n', '<Leader>dh', function() require('dap.ui.widgets').hover() end)
  end,
}
