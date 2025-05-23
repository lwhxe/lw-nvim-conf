return {
	"renerocksai/telekasten.nvim",
	dependencies = { "nvim-telescope/telescope.nvim" },  -- If you use Telescope
	config = function()
		require("telekasten").setup({
			home = "C:/telekasten/",  -- Set the path to your notes directory
			auto_set_filetype = true,
			-- Add any other options you need
		})
	end
}
