-- NOTE: select block and do gc to comment
return {
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},
}
