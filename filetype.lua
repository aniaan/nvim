vim.filetype.add({
  pattern = {
    [".*/ghostty/config"] = "ghostty",
    ["%.env%.[%w_.-]+"] = "sh",
    [".*"] = {
      function(path, buf)
        if
          vim.bo[buf]
          and vim.bo[buf].filetype ~= "bigfile"
          and path
          and vim.fn.getfsize(path) > (1024 * 500) -- 500 KB
        then
          return "bigfile"
        end
        return nil
      end,
    },
  },
})
vim.treesitter.language.register("bash", "ghostty")
