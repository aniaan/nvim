local fetch_leetcode_problem_prompt_temlate = [[
For LeetCode problem %s, provide a Rust code template following this exact structure:

1. First: Problem description and metadata as comments:
// LeetCode Problem %s
// 
// [Problem description wrapped at 60 chars per line]
//
// Examples(provide at least two example):
// Input: <example input>
// Output: <example output>
//
// Constraints: 
// [List each constraint on a new line]

2. Second: Any required helper structs/types (if needed):
// Definition for required data structures
[Include any struct definitions needed for the problem]

3. Third: Empty implementation:
impl Solution <left_brace>
    pub fn <function_name>(<params>) -> <return_type> <left_brace>
        unimplemented!()
    <right_brace>
<right_brace>

struct Solution;

4. Fourth: Test structure:
#[cfg(test)]
mod tests <left_brace>
    use super::*;

    #[test]
    fn test_<function_name>() <left_brace>
        assert_eq!(<expected>, Solution::<function_name>(<test_input>));
    <right_brace>
<right_brace>

Important:
- Follow this exact order: comments -> helper structs -> implementation -> tests
- Include any necessary struct definitions as provided in the LeetCode problem
- Do not include any actual implementation code
- Do not include any markdown formatting
- Wrap all comment lines at 60 characters
- Include at least three test case
- write to {file}
]]
return {
  {
    require("consts").SIDE_KICK,
    event = "VeryLazy",
    opts = {
      nes = {
        enabled = vim.g.copilot_enabled, -- Enable Next Edit Suggestions
      },
      cli = {
        prompts = {
          leetcode = function(ctx)
            local buf = ctx.buf
            local file = vim.api.nvim_buf_get_name(buf)
            local problem_id = file:match("l(%d+)")
            if not problem_id then return '' end
            problem_id = tostring(tonumber(problem_id)) -- remove leading zeros
            return string.format(fetch_leetcode_problem_prompt_temlate, problem_id, problem_id)
          end,
        },
      },
    },
    keys = {
      {
        "<tab>",
        function()
          -- if there is a next edit, jump to it, otherwise apply it if any
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>" -- fallback to normal tab
          end
        end,
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      },

      {
        "<leader>aa",
        function() require("sidekick.cli").toggle() end,
        desc = "Sidekick Toggle CLI",
      },
      {
        "<leader>as",
        function() require("sidekick.cli").select() end,
        -- Or to select only installed tools:
        -- require("sidekick.cli").select({ filter = { installed = true } })
        desc = "Select CLI",
      },

      {
        "<leader>at",
        function() require("sidekick.cli").send({ msg = "{this}" }) end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        "<leader>af",
        function() require("sidekick.cli").send({ msg = "{file}" }) end,
        desc = "Send File",
      },
      {
        "<leader>av",
        function() require("sidekick.cli").send({ msg = "{selection}" }) end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>ap",
        function() require("sidekick.cli").prompt() end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
    },
  },
}
