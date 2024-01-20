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
    vim.keymap.set('n', '<Leader>lg', '<cmd>Telescope lsp_definitions<cr>', { silent = true, noremap = true, desc = 'Go to Definition'})
    vim.g.editorconfig = true

    vim.opt.tabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.expandtab = true
    vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false, silent = true, noremap = true, desc = "Accept Copilot Suggestion"})
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    local dap = require('dap')
    dap.adapters.coreclr = {
      type = 'executable',
      command = 'C:/Program Files/Netcoredbg/netcoredbg.exe',
      args = { '--interpreter=vscode'},
      options = {
        detached = false,
      }
    }

    dap.configurations.cs = {
      {
        type = 'coreclr',
        name = 'launch - netcoredbg',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/', 'file')
        end,
      }
    }

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
