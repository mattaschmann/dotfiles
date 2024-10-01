-- for testing
return {
	'https://github.com/vim-test/vim-test',
	dependencies = {
		'https://github.com/preservim/vimux'
	},
	keys = {
		{'<localleader>t', '<cmd>TestNearest<cr>', {silent = true}}
	},
	config = function()
		vim.cmd([[
			let test#python#runner = 'pytest'
			let test#strategy = 'vimux'
		]])
	end

}
