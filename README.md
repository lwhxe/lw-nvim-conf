### LWHXE NeoVim Config

This is a very simple NeoVim configuration, intended to work for most languages.

Features:
- Debug Adapter Protocol for specific languages
- Autocomplete and Syntax Highlighting
- File Management
- Note Creation

Note: Java LSP is currently broken. It may not work as intended for you.

---

### Installation Guide

Install [NeoVim](https://github.com/neovim/neovim) for Windows.
Make sure to follow the installation steps.

    cd %appdata%/../Local
    mkdir nvim
    git clone https://github.com/lwhxe/lw-nvim-conf nvim

Now run the "nvim" command from anywhere in the terminal. Wait 1-5 minutes for the install to complete.
\
*Grab a coffee or something.*
\
\
There might be errors. To fix this, just restart NeoVim by using ":q" and running the command again.

---

### LSP & DAP Specifics

For specific LSP and DAP related functions like (Autocomplete, Debugging, ...) certain language servers have dependencies that you have to install.\
The config will not initialize nor install any LSP or DAP that has a missing dependency.\
\
For example: "gopls" is the Go Programming Language Server. Of course the Go Programming Language is a dependency.\
This means the "go.exe" must be found in the PATH variable.\
\
For more information related to LSP & DAP Specifics, please read: (COMING SOON).

---

### Updating Guide

If NeoVim receives an update, then reinstall using this ([NeoVim](https://github.com/neovim/neovim)).\
\
Pasting these commands into any command prompt should suffice for updating the config files.

    cd %appdata%/../Local/nvim
    git pull

If it does not, please open an issue request.

---

### Submit requests or issues

I want you to submit requests or bugfixes whenever you notice something off.\
If I might have done something wrong, I want to fix it immediately.\
\
Please give sufficient details on your problem, maybe some code or context what you're working on/with.
