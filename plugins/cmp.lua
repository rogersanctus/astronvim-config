return {
  "hrsh7th/nvim-cmp",
  opts = function(_, opts)
    local cmp = require "cmp"
    local lspkind = require "lspkind"

    local sources = {
      -- { name = 'nvim-lsp', trigger_characters = { '-' } }
    }

    vim.tbl_deep_extend("force", opts.sources, sources)

    opts.completion = {
      autocomplete = {
        cmp.TriggerEvent.TextChanged,
        cmp.TriggerEvent.InsertEnter,
      },
      completeopt = "menuone,noinsert,noselect",
      keyword_length = 0,
    }

    opts.window = {
      completion = {
        col_offset = 3,
      },
    }

    opts.formatting = {
      fields = { "kind", "abbr", "menu" },
      format = lspkind.cmp_format {
        mode = "symbol_text",
        maxwidth = 50,
        before = function(entry, vim_item)
          if vim_item.kind == "Color" and entry.completion_item.documentation then
            local _, _, r, g, b = string.find(entry.completion_item.documentation, "^rgb%((%d+), (%d+), (%d+)")

            if r and g and b then
              local color = string.format("%02x%02x%02x", r, g, b)
              local group = "Tw_" .. color

              if vim.fn.hlID(group) < 1 then
                vim.api.nvim_set_hl(0, group, {
                  fg = "#" .. color,
                })
              end

              vim_item.kind = "■"
              vim_item.kind_hl_group = group
              return vim_item
            end
          end

          vim_item.kind = lspkind.symbolic(vim_item.kind) or vim_item.kind

          return vim_item
        end,
      },
    }

    return opts
  end,
}
