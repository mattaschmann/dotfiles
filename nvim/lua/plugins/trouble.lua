-- diagnostic window
return {
  'https://github.com/folke/trouble.nvim',
	opts = {},
	keys = {
	  {
	    'gL',
	    "<cmd>call coc#rpc#request('fillDiagnostics', [bufnr('%')])<CR><cmd>Trouble loclist<CR>`",
	    desc = 'Open coc diagnostics in trouble',
	    {
	      silent = true
	    }
	  },
	}
}
