return {
  'hrsh7th/nvim-cmp',
  opts = function(_, opts)
    local cmp = require('cmp')

    local sources = {
      -- { name = 'nvim-lsp', trigger_characters = { '-' } }
    }

    vim.tbl_deep_extend('force', opts.sources, sources)

    opts.completion = {
		  autocomplete = {
			  cmp.TriggerEvent.TextChanged,
			  cmp.TriggerEvent.InsertEnter,
		  },
		  completeopt = "menuone,noinsert,noselect",
		  keyword_length = 0
	  }

    return opts
  end

}
