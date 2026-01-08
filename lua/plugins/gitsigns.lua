return {
  {
    require("consts").GITSIGNS,
    event = "VeryLazy",
    opts = {
      signcolumn = false,
      numhl = true,
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        ---@param lhs string
        ---@param rhs function
        ---@param desc string
        local function nmap(lhs, rhs, desc) vim.keymap.set("n", lhs, rhs, { desc = desc, buffer = buffer }) end

        nmap("[h", gs.prev_hunk, "Previous hunk")
        nmap("]h", gs.next_hunk, "Next hunk")
        nmap("<leader>gR", gs.reset_buffer, "Reset buffer")
        nmap("<leader>gb", gs.blame_line, "Blame line")
        nmap("<leader>gp", gs.preview_hunk, "Preview hunk")
        nmap("<leader>gr", gs.reset_hunk, "Reset hunk")
        nmap("<leader>gs", gs.stage_hunk, "Stage hunk")
      end,
    },
  },
}
