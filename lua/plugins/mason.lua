return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup {
                ensure_installed = { "codelldb" }, -- replace/add any tools you want here
            }
        end,
    },
}
