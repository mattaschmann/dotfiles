return {
	'https://github.com/ibhagwan/fzf-lua.git',
	-- optional for icon support
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	keys = {
		{'<Leader>p', '<cmd>FzfLua commands<cr>', desc = 'Fuzzy search commands'},
		{'<Leader>e', '<cmd>FzfLua files<cr>', desc = 'Fuzzy search files'},
		{'<Leader>f', '<cmd>FzfLua live_grep<cr>', desc = 'Fuzzy find in files'},
		{'<leader>f', 'y:FzfLua grep search=<C-R>0<cr>', mode = 'v', desc = 'Fuzzy find on current selection'},
		{'<Leader>l', '<cmd>FzfLua blines<CR>', desc = 'Fuzzy search lines in current file'},
		{'<Leader>h', '<cmd>FzfLua helptags<CR>', desc = 'Fuzzy search help'},
		{'<Leader>b', '<cmd>FzfLua buffers<CR>', desc = 'Fuzzy search buffers'},
		{'<leader>m', '<cmd>FzfLua grep search=@Matt<cr>', desc = 'Find @Matts'},
		{'<leader>?', '<cmd>FzfLua keymaps<cr>', desc = 'Search keymaps'},
		{'<leader>r', '<cmd>FzfLua resume<cr>', desc = 'Resume last operation'},
	},
	config = function()
		local actions = require 'fzf-lua.actions'
		require('fzf-lua').setup({
			winopts = {
				preview = {
					layout = 'vertical',
				},
			},
			grep = {
				actions = {
					['ctrl-r'] = { actions.toggle_ignore }
				},
				rg_opts = '--hidden --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e',
			},
			files = {
				previewer = false
			},
			lines = {
				previewer = false
			}
		})
	end,
}
