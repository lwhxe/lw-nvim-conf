vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 20
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.clipboard = 'unnamedplus'

-- Define a function to toggle the terminal
_G.toggle_terminal = function()
    local term_bufnr = vim.g.terminal_bufnr

    if term_bufnr and vim.api.nvim_buf_is_valid(term_bufnr) then
        -- If the terminal buffer exists, toggle it
        if vim.fn.bufwinnr(term_bufnr) > 0 then
            vim.cmd('bdelete ' .. term_bufnr)
        else
            vim.cmd('buffer ' .. term_bufnr)
        end
    else
        -- Create a new terminal buffer
        vim.cmd('terminal')
        vim.g.terminal_bufnr = vim.fn.bufnr('%')
    end
end

-- Map <leader>v to toggle the terminal
vim.api.nvim_set_keymap('n', '<leader>v', ':lua toggle_terminal()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })

-- Rust Stuff
-- vim.api.nvim_set_keymap('n', '<leader>rr', '<cmd>RustReloadWorkspace<CR>', { noremap = true, silent = true })
