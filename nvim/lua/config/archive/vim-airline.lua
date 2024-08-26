-- bottom status bar
return {
	'https://github.com/vim-airline/vim-airline',
	lazy = false,
	priority = 1000,
	opts = {},
	config = function()
		vim.g['airline#extensions#tabline#enabled'] = 1
		vim.g.airline_powerline_fonts = 1
	end
}

