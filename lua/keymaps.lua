local map = vim.keymap.set

-- ============================================================================
-- 基础移动增强
-- ============================================================================
-- 更智能的上下移动（处理折行）
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
map({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })
map({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })

-- 全选
map('n', '<C-a>', 'ggVG', { desc = 'Select All' })

-- ============================================================================
-- 插入模式光标移动
-- ============================================================================
map('i', '<C-h>', '<Left>', { desc = 'Move Left' })
map('i', '<C-j>', '<Down>', { desc = 'Move Down' })
map('i', '<C-k>', '<Up>', { desc = 'Move Up' })
map('i', '<C-l>', '<Right>', { desc = 'Move Right' })

-- ============================================================================
-- 窗口管理
-- ============================================================================
-- 窗口切换
map('n', '<C-h>', '<C-w>h', { desc = 'Go to Left Window', remap = true })
map('n', '<C-j>', '<C-w>j', { desc = 'Go to Lower Window', remap = true })
map('n', '<C-k>', '<C-w>k', { desc = 'Go to Upper Window', remap = true })
map('n', '<C-l>', '<C-w>l', { desc = 'Go to Right Window', remap = true })

-- 窗口大小调整
map('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase Window Height' })
map('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease Window Height' })
map('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease Window Width' })
map('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase Window Width' })

-- 窗口菜单快捷键
map('n', '\\', '<C-w>', { desc = 'Show Window menu', remap = true })

-- ============================================================================
-- 行移动和文本操作
-- ============================================================================
local function move_line(direction)
  local count = vim.v.count1
  local cmd = direction == 'down' and string.format('move .+%d', count) or string.format('move .-%d', count + 1)
  vim.cmd(cmd)
  vim.cmd('normal! ==')
end

local function move_block(direction)
  local count = vim.v.count1
  local cmd = direction == 'down' and string.format("'<,'>move '>+%d", count)
    or string.format("'<,'>move '<-%d", count + 1)
  vim.cmd(cmd)
  vim.cmd('normal! gv=gv')
end

-- 移动行（普通模式）
map('n', '<A-j>', function() move_line('down') end, { desc = 'Move Line Down' })

map('n', '<A-k>', function() move_line('up') end, { desc = 'Move Line Up' })

-- 移动选中块（可视模式）
map('v', '<A-j>', function() move_block('down') end, { desc = 'Move Block Down' })
map('v', '<A-k>', function() move_block('up') end, { desc = 'Move Block Up' })

-- 缩进辅助函数
local function indent(direction)
  local count = vim.v.count1
  local cmd = direction == 'left' and '<<' or '>>'
  for _ = 1, count do
    vim.cmd('normal! ' .. cmd)
  end
end

local function indent_block(direction)
  indent(direction)
  vim.cmd('normal! gv')
end

-- 普通模式缩进
map('n', '<A-h>', function() indent('left') end, { desc = 'Indent Left' })

map('n', '<A-l>', function() indent('right') end, { desc = 'Indent Right' })

-- 可视模式缩进
map('v', '<A-h>', function() indent_block('left') end, { desc = 'Indent Block Left' })
map('v', '<A-l>', function() indent_block('right') end, { desc = 'Indent Block Right' })

-- ============================================================================
-- 缓冲区导航
-- ============================================================================
map('n', '[b', '<cmd>bprevious<cr>', { desc = 'Previous Buffer' })
map('n', ']b', '<cmd>bnext<cr>', { desc = 'Next Buffer' })

-- ============================================================================
-- 快速列表导航
-- ============================================================================
map('n', '[q', vim.cmd.cprev, { desc = 'Previous Quickfix' })
map('n', ']q', vim.cmd.cnext, { desc = 'Next Quickfix' })

-- ============================================================================
-- 诊断导航
-- ============================================================================
-- 诊断跳转助手函数
local diagnostic_goto = function(next, severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.jump({
      count = next and 1 or -1,
      severity = severity,
    })
  end
end

-- 通用诊断导航
map('n', ']d', diagnostic_goto(true), { desc = 'Next Diagnostic' })
map('n', '[d', diagnostic_goto(false), { desc = 'Previous Diagnostic' })

-- 错误导航
map('n', ']e', diagnostic_goto(true, 'ERROR'), { desc = 'Next Error' })
map('n', '[e', diagnostic_goto(false, 'ERROR'), { desc = 'Previous Error' })

-- 警告导航
map('n', ']w', diagnostic_goto(true, 'WARN'), { desc = 'Next Warning' })
map('n', '[w', diagnostic_goto(false, 'WARN'), { desc = 'Previous Warning' })

-- 显示诊断详情
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Show Line Diagnostics' })

-- ============================================================================
-- 文件操作
-- ============================================================================
-- 保存文件
map('n', '<leader>fs', '<cmd>silent! wa | redrawstatus<cr>', { desc = 'Save All Files', silent = true })

-- 新建文件
map('n', '<leader>fn', '<cmd>enew<cr>', { desc = 'New File' })

-- ============================================================================
-- 应用程序控制
-- ============================================================================
-- 退出应用
-- map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- 插件管理
map('n', '<leader>l', '<cmd>Lazy<cr>', { desc = 'Open Lazy Plugin Manager' })

-- ============================================================================
-- 开发工具
-- ============================================================================
-- 语法高亮检查
map('n', '<leader>ui', vim.show_pos, { desc = 'Inspect Position' })
map('n', '<leader>uI', function()
  vim.treesitter.inspect_tree()
  vim.api.nvim_input('I')
end, { desc = 'Inspect Treesitter Tree' })

-- ============================================================================
-- 特殊功能和覆盖
-- ============================================================================
-- 禁用默认的 q（录制宏）
map('n', 'q', '<Nop>', { desc = 'Disabled (no macro recording)', silent = true })

-- 增强的 Escape 功能
map({ 'i', 'n', 's' }, '<esc>', function()
  vim.cmd('noh') -- 清除搜索高亮
  if vim.snippet then
    vim.snippet.stop() -- 停止代码片段
  end
  return '<esc>'
end, { expr = true, desc = 'Escape, Clear Search, Stop Snippets' })

-- terminal
map('n', '<c-/>', function() Snacks.terminal(nil, { cwd = vim.uv.cwd() }) end, { desc = 'Terminal (Root Dir)' })
map('t', '<C-/>', '<cmd>close<cr>', { desc = 'Hide Terminal' })

-- buffer
map('n', '<leader>bd', function() Snacks.bufdelete() end, { desc = 'Delete Buffer' })
map('n', '<leader>bo', function() Snacks.bufdelete.other() end, { desc = 'Delete Other Buffers' })

-- ui

vim.keymap.set('n', '<leader>ut', function() require('base46').pick_theme() end, { desc = 'Pick Theme' })

vim.keymap.set('n', '<leader>uo', function() require('utils.tools').pick_tool() end, { desc = 'Pick Tool' })
