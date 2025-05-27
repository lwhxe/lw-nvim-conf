if vim.fn.executable("%appdata%/../Local/nvim/UPDATE.bat") == 1 then
    os.execute("%appdata%/../Local/nvim/UPDATE.bat")
end

require("lwhxe")
