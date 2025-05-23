vim.keymap.set("n", "<leader>tn", function()
  require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

vim.keymap.set("n", "<leader>tp", function()
  require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })
