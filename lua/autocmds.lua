local function augroup(name) return vim.api.nvim_create_augroup("aniaan/" .. name, { clear = true }) end

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then vim.cmd("checktime") end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function() (vim.hl or vim.highlight).on_yank() end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then vim.cmd('normal! g`"zz') end
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  desc = "Close with <q>",
  pattern = {
    "git",
    "help",
    "man",
    "qf",
    "scratch",
  },
  callback = function(args) vim.keymap.set("n", "q", "<cmd>quit<cr>", { buffer = args.buf }) end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("json_conceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function() vim.opt_local.conceallevel = 0 end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  group = augroup("rust_flycheck"),
  pattern = "*.rs",
  callback = function()
    vim.schedule(function() require("utils").rust_flycheck("run") end)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("treesitter_folding"),
  desc = "Enable Treesitter folding",
  callback = function(args)
    local bufnr = args.buf
    if vim.bo[bufnr].filetype ~= "bigfile" and pcall(vim.treesitter.start, bufnr) then
      vim.api.nvim_buf_call(bufnr, function()
        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.cmd.normal("zx")
      end)
    else
      vim.wo.foldmethod = "indent"
    end
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = augroup("winbar"),
  desc = "Attach winbar",
  callback = function(args)
    if
      not vim.api.nvim_win_get_config(0).zindex -- Not a floating window
      and vim.bo[args.buf].buftype == "" -- Normal buffer
      and vim.api.nvim_buf_get_name(args.buf) ~= "" -- Has a file name
      and not vim.wo[0].diff -- Not in diff mode
    then
      vim.wo.winbar = "%{%v:lua.require'winbar'.get()%}"
    end
  end,
})
