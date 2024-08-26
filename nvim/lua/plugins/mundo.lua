return {
	-- Undo branching visualization
	'https://github.com/simnalamburt/vim-mundo',
	config = function()
		vim.cmd([[
			set undofile
			set undodir=~/.config/nvim/undo
		]])
	end
}
