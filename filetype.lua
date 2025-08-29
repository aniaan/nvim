vim.filetype.add({
  pattern = {
    [".*/kitty/.+%.conf"] = "kitty",
    [".*/ghostty/config"] = "ghostty",
    ["%.env%.[%w_.-]+"] = "sh",
    [".*"] = {
      function(path, buf)
        local size_limit = 500 * 1024
        if not path or not buf or vim.bo[buf].filetype == "bigfile" then return end
        if path ~= vim.api.nvim_buf_get_name(buf) then return end
        local size = vim.fn.getfsize(path)
        if size > size_limit then return "bigfile" end
      end,
    },
  },
})
vim.treesitter.language.register("bash", "kitty")
vim.treesitter.language.register("bash", "ghostty")
