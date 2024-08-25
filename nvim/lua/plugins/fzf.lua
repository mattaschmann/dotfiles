return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{"<Leader>p", "<cmd>FzfLua commands<cr>", desc = "Fuzzy search commands"},
		{"<Leader>e", "<cmd>FzfLua files<cr>", desc = "Fuzzy search files"},
		{"<Leader>f", "<cmd>FzfLua live_grep<cr>", desc = "Fuzzy find in files"},
		{"<Leader>l", "<cmd>FzfLua lines<CR>", "Fuzzy search lines in current file"},
		{"<Leader>h", "<cmd>FzfLua helptags<CR>", "Fuzzy search help"},
		{"<Leader>b", "<cmd>FzfLua buffers<CR>", "Fuzzy search buffers"},
	},
	config = function()
		local actions = require "fzf-lua.actions"
		require("fzf-lua").setup({
			grep = {
				actions = {
					["ctrl-r"] = { actions.toggle_ignore }
				},
				rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
			},
			files = {
				previewer = 'false'
			},
			lines = {
				previewer = 'false'
			}
		})
	end,
}
