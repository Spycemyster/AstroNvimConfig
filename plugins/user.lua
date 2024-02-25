return {
  -- "sbdchd/neoformat",
  -- You can also add new plugins here as well:
  -- Add plugins, the lazy syntax
  -- "andweeb/presence.nvim",
  -- {
  --  "ray-x/lsp_signature.nvim",
  --  event = "BufRead",
  --  config = function()
  --    require("lsp_signature").setup()
  --  end,
  --},,
    {
        "Decodetalkers/csharpls-extended-lsp.nvim",
        --[[
        config = function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            -- local csharpls = "C:\\Users\\lalam\\AppData\\Local\\nvim-data\\mason\\packages\\csharp-language-server\\csharp-ls.exe"
            local config = {
                handlers = {
                  ["textDocument/definition"] = require('csharpls_extended').handler,
                  ["textDocument/typeDefinition"] = require('csharpls_extended').handler,
            },
            capabilities = capabilities,
            cmd = { 'csharp-ls' },
          }

            require'lspconfig'.csharp_ls.setup(config)
        end
        --]]
    },
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup()
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        event = { "InsertEnter", "LspAttach" },
        config = function ()
            require("copilot_cmp").setup({

            })
        end
    },
    {
        "mfussenegger/nvim-dap",
        enabled = true,
    },
    {
        "rcarriga/nvim-dap-ui",
    },
    {
        'nvim-ts-autotag',
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = "VeryLazy",
        opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        }
    },
    {
      'rmagatti/goto-preview',
      config = function()
        require('goto-preview').setup {}
      end
    },
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup()
        end
    },
    {
        "Spycemyster/dotnet-goto.nvim",
        event = "InsertEnter",
        config = function()
            vim.keymap.set("n", "gd", "<Cmd>lua require('dotnet-goto').lsp_request_definition()<CR>", { noremap = false, silent = true, desc="Go to Definition (dotnet)" })
        end
    }
}
