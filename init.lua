if vim.fn.executable("%appdata%/../Local/nvim/UPDATE.bat") == 1 then
    os.execute("%appdata%/../Local/nvim/UPDATE.bat")
end

os.execute("cd C:/")
os.execute("mkdir telekasten")

require("lwhxe")

vim.api.nvim_create_autocmd("VimEnter",{callback=function()require"lazy".update({show = false})end})
