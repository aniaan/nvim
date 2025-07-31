vim.filetype.add({
  pattern = {
    [".*/kitty/.+%.conf"] = "kitty",
    [".*/ghostty/config"] = "ghostty",
    ["%.env%.[%w_.-]+"] = "sh",
  },
})
vim.treesitter.language.register("bash", "kitty")
vim.treesitter.language.register("bash", "ghostty")
