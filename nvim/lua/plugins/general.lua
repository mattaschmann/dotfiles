return {
	-- auto close pairs
	{
		'https://github.com/m4xshen/autoclose.nvim',
		opts = {},
	},

	-- Close all buffers but current/specified one
	{
		'https://github.com/schickling/vim-bufonly',
		keys = {
			{'<leader>O', ':Bonly<cr>', desc = 'Close other buffers', silent = true}
		}
	},

	-- git gutter
	'https://github.com/airblade/vim-gitgutter',

	-- edit macros
	'https://github.com/dohsimpson/vim-macroeditor',

	-- sane window removal management
	{
		'https://github.com/mhinz/vim-sayonara',
		keys = {
			{'<Leader>w,', ':Sayonara!<CR>', silent = true},
			{'<Leader>q', ':Sayonara<CR>', silent = true},
		},
	},

	-- css colors
	'https://github.com/ap/vim-css-color',

	-- alignment
	'https://github.com/junegunn/vim-easy-align',

	-- diff stuff
	{
		'https://github.com/sindrets/diffview.nvim',
		keys = {
			{'<Leader>do', ':DiffviewOpen<CR>'},
			{'<Leader>dh', ':DiffviewFileHistory %<CR>'},
		}
	},

	-- Start screen
	{
		'https://github.com/mhinz/vim-startify',
		config = function()
			vim.g.startify_change_to_dir = 0
		end,
	},
	

	-- Better matching
	'https://github.com/andymass/vim-matchup',

	-- Whitespace trimmer
	'https://github.com/KorySchneider/vim-trim',

	-- local config safety
	'https://github.com/klen/nvim-config-local',

	-- helm
	'https://github.com/towolf/vim-helm',

	-- terraform
	'https://github.com/hashivim/vim-terraform',

}
