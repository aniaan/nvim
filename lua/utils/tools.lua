local M = {}
local H = {}
local R = {}

H.binary_to_decimal = function(binary)
  if not binary or binary == "" then return end

  local decimal = 0
  local binary_len = string.len(binary)
  for i = 1, binary_len do
    local bit = string.sub(binary, binary_len - i + 1, binary_len - i + 1)
    decimal = decimal + tonumber(bit) * 2 ^ (i - 1)
  end
  return tostring(decimal)
end

H.str_decimal_to_binary = function(word)
  if not word or word == "" then return end

  local decimal = tonumber(word)

  if decimal == 0 then return "0" end

  if decimal < 0 then return nil end

  local binary = ""
  while decimal > 0 do
    binary = decimal % 2 .. binary
    decimal = math.floor(decimal / 2)
  end
  return binary
end

M.pick_tool = function()
  local tools = {}
  for func_name, _ in pairs(R) do
    table.insert(tools, { text = func_name, file = func_name })
  end

  Snacks.picker.pick({
    source = "tools",
    items = tools,
    format = "text",
    layout = require("utils.picker").normal_layout.layout,
    confirm = function(picker, item)
      picker:close()
      local tool_name = item.text
      if tool_name then
        vim.schedule(function()
          if R[tool_name] then
            R[tool_name]()
          else
            vim.notify("Tool not found: " .. tool_name, vim.log.levels.ERROR)
          end
        end)
      end
    end,
  })
end

H.convert_current_word_to_x = function(convert_func)
  local word = vim.fn.expand("<cword>")

  local value = convert_func(word)

  if not value then
    vim.notify("Could to convert", vim.log.levels.ERROR)
    return
  end

  local line = vim.fn.line(".")

  local start_pos = vim.fn.searchpos("\\<" .. word .. "\\>", "bcn")
  local end_pos = vim.fn.searchpos("\\<" .. word .. "\\>", "cen")

  if start_pos[2] == 0 or end_pos[2] == 0 then
    vim.notify("Could not find word boundaries", vim.log.levels.ERROR)
    return
  end

  vim.api.nvim_buf_set_text(
    0, -- 当前buffer
    line - 1, -- 起始行
    start_pos[2] - 1, -- 起始列
    line - 1, -- 结束行
    end_pos[2], -- 结束列
    { value } -- 替换文本
  )
end

R.convert_current_word_to_binary = function() H.convert_current_word_to_x(H.str_decimal_to_binary) end

R.convert_current_word_to_decimal = function() H.convert_current_word_to_x(H.binary_to_decimal) end

local fetch_leetcode_problem_prompt_temlate = [[
For LeetCode problem %s, provide a Rust code template following this exact structure:

1. First: Problem description and metadata as comments:
// LeetCode Problem %s
// 
// [Problem description wrapped at 60 chars per line]
//
// Examples(provide at least two example):
// Input: {example input}
// Output: {example output}
//
// Constraints: 
// [List each constraint on a new line]

2. Second: Any required helper structs/types (if needed):
// Definition for required data structures
[Include any struct definitions needed for the problem]

3. Third: Empty implementation:
impl Solution {
    pub fn {function_name}({params}) -> {return_type} {
        unimplemented!()
    }
}

struct Solution;

4. Fourth: Test structure:
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_{function_name}() {
        assert_eq!({expected}, Solution::{function_name}({test_input}));
    }
}

Important:
- Follow this exact order: comments -> helper structs -> implementation -> tests
- Include any necessary struct definitions as provided in the LeetCode problem
- Do not include any actual implementation code
- Do not include any markdown formatting
- Wrap all comment lines at 60 characters
- Include at least one test case
]]

return M
