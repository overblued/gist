-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

-- vim.opt.guicursor = ""
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true


-- wrap的同时保持indent
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.colorcolumn = "120"
vim.g.mapleader = " "







-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- V
-- 下JK可以将选择行上下移动
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
-- P：用_替换高亮的内容, 不修改_
vim.keymap.set("v", "P", [["_dP]])

-- N
-- 合并行以后光标不动
vim.keymap.set("n", "J", "mzJ`z")
-- 翻页以后光标始终在中央
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- 搜索时,当前行始终在中央
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
--全局替换当前word
vim.keymap.set("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]])
--wrap时jk到wrap的的相对行而不是绝对行
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- 快速编辑当前配置
vim.keymap.set("n", "<leader>voo", "<cmd>e ~/.config/nvim/init.lua<CR>");
-- C
-- 用sudo保存当前文件
vim.keymap.set('c', 'w!!', 'w !sudo tee %')
-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")
--
-- next greatest remap ever : asbjornHaland
-- vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
-- vim.keymap.set("n", "<leader>Y", [["+Y]])

-- vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", 'gt', "<cmd>diffget //2<CR>")
vim.keymap.set("n", 'gy', "<cmd>diffget //3<CR>")
vim.keymap.set("t","<A-h>", "<C-\\><C-N><C-w>h")
vim.keymap.set("t","<A-j>", "<C-\\><C-N><C-w>j")
vim.keymap.set("t","<A-k>", "<C-\\><C-N><C-w>k")
vim.keymap.set("t","<A-l>", "<C-\\><C-N><C-w>l")
vim.keymap.set("i","<A-h>", "<C-\\><C-N><C-w>h")
vim.keymap.set("i","<A-j>", "<C-\\><C-N><C-w>j")
vim.keymap.set("i","<A-k>", "<C-\\><C-N><C-w>k")
vim.keymap.set("i","<A-l>", "<C-\\><C-N><C-w>l")
vim.keymap.set("n","<A-h>", "<C-w>h")
vim.keymap.set("n","<A-j>", "<C-w>j")
vim.keymap.set("n","<A-k>", "<C-w>k")
vim.keymap.set("n","<A-l>", "<C-w>l")
vim.keymap.set({"n","i","v"},"<C-\\><C-\\>", "<cmd>vsplit | terminal<CR>")






vim.api.nvim_create_autocmd('BufReadPost', {
--  group = vim.g.user.event,
  callback = function(args)
    local valid_line = vim.fn.line([['"]]) >= 1 and vim.fn.line([['"]]) < vim.fn.line('$')
    local not_commit = vim.b[args.buf].filetype ~= 'commit'

    if valid_line and not_commit then
      vim.cmd([[normal! g`"]])
    end
  end,
})
