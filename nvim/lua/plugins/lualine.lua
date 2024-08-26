-- status line
return {
	'nvim-lualine/lualine.nvim',
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	opts = {
		options = {
			theme = 'auto'
		},
		extensions = {
			'quickfix',
			'lazy',
			'fugitive',
			'fzf',
			'man',
			'mundo',
			'nvim-tree',
			'trouble',
		},
		tabline = {
			lualine_a = {'buffers'},
			lualine_b = {},
			lualine_c = {},
			lualine_x = {},
			lualine_y = {},
			lualine_z = {'tabs'}
		},
	}
}
