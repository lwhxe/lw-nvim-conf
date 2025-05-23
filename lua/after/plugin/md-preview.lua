-- Key mapping to toggle Markdown preview
vim.keymap.set('n', '<leader>md', function()
    vim.cmd("MarkdownPreviewToggle")
end, { desc = 'Toggle Markdown Preview' })

