-- stylua: ignore start
-- ============================================================================
-- Leader 键设置
-- ============================================================================
vim.g.mapleader = " "      -- 设置主 leader 键为空格
vim.g.maplocalleader = " " -- 设置本地 leader 键为反斜杠（ 默认）
vim.g.snacks_animate = false

-- ============================================================================
-- 性能优化 - 禁用不需要的功能
-- ============================================================================
vim.g.loaded_python3_provider = 0  -- 禁用Python3提供者，提高启动速度
vim.g.loaded_perl_provider = 0     -- 禁用Perl提供者
vim.g.loaded_ruby_provider = 0     -- 禁用Ruby提供者
vim.g.loaded_node_provider = 0     -- 禁用Node.js提供者

local opt = vim.opt

-- ============================================================================
-- 基础编辑器设置
-- ============================================================================
opt.termguicolors = true              -- 启用真彩色支持，让颜色更丰富准确
opt.mouse = "a"                       -- 在所有模式下启用鼠标支持
opt.mousescroll = "ver:3,hor:0"       -- 鼠标滚轮设置：垂直滚动3行，禁用水平滚动
opt.swapfile = false
opt.undofile = true                   -- 启用持久化撤销，重启后仍可撤销
opt.cursorline = true                 -- 高亮当前行
opt.wrap = false                    -- 禁用自动换行
opt.clipboard = "unnamedplus"     -- 非 SSH 环境下与系统剪贴板同步

-- ============================================================================
-- 缩进和制表符设置
-- ============================================================================
opt.sw = 2              -- 自动缩进时使用2个空格（ 默认）
opt.ts = 2              -- Tab键显示为2个空格的宽度（ 默认）
opt.et = true           -- 将Tab键转换为空格
opt.smartindent = true  -- 智能缩进，根据语法自动调整缩进
opt.shiftround = true   -- 缩进时四舍五入到 shiftwidth 的倍数

-- ============================================================================
-- 显示和界面设置
-- ============================================================================
opt.list = true                                -- 显示不可见字符（空格、Tab等）
opt.listchars = "tab:» ,trail:·,nbsp:·"      -- 设置不可见字符的显示样式
opt.signcolumn = "number"                         -- 始终显示标志列，避免文本跳动
opt.linebreak = true                            -- 在单词边界处换行，不会截断单词
opt.number = true                             -- 显示行号
-- opt.relativenumber = false                     -- 显示相对行号
opt.cmdheight = 0                             -- 命令行高度为0（极简模式）
opt.laststatus = 3                            -- 全局状态栏
opt.confirm = true
opt.ruler = false                             -- 禁用默认标尺
opt.showmode = false                          -- 不显示模式（因为有状态栏）
opt.showtabline = 0


-- 填充字符设置
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

-- 窗口设置
opt.splitbelow = true                 -- 新窗口在当前窗口下方打开
opt.splitright = true                -- 新窗口在当前窗口右侧打开
opt.splitkeep = "screen"              -- 保持屏幕位置
opt.winminwidth = 5                   -- 最小窗口宽度

-- ============================================================================
-- 光标和滚动设置
-- ============================================================================
opt.guicursor =                     -- 光标样式设置，禁用闪烁
  "n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor,t:ver25-Cursor"

opt.smoothscroll = true             -- 启用平滑滚动

-- ============================================================================
-- 折叠设置
-- ============================================================================
opt.foldlevelstart = 99    -- 打开文件时展开所有折叠
opt.foldtext = ""

-- ============================================================================
-- 搜索设置
-- ============================================================================
opt.ignorecase = true        -- 搜索时忽略大小写
opt.smartcase = true         -- 如果搜索包含大写字母，则区分大小写

-- ============================================================================
-- 时间和响应设置
-- ============================================================================
opt.updatetime = 300      -- 保存交换文件和触发 CursorHold 的时间（毫秒）
opt.timeoutlen = 500        -- 等待按键序列的时间，VSCode 中设置更长
opt.ttimeoutlen = 10        -- 等待终端按键码的时间（毫秒）

-- ============================================================================
-- 补全和弹出菜单设置
-- ============================================================================
opt.wildignore:append({ ".DS_Store" })      -- 文件补全时忽略.DS_Store文件
opt.completeopt = "menu,menuone,noselect"     -- 补全菜单行为：显示菜单，即使只有一项，不自动选择
opt.pumheight = 10                            -- 弹出菜单最大显示10项
opt.pumblend = 10                             -- 弹出菜单透明度（0-100）

-- ============================================================================
-- 高级编辑功能
-- ============================================================================
-- opt.virtualedit = "block"                     -- 在可视块模式下允许光标移动到没有文本的位置
-- opt.diffopt:append("vertical,context:99")   -- diff模式：垂直分割，显示大量上下文
-- opt.formatoptions = "jcroqlnt"              -- 文本格式化选项
-- opt.jumpoptions = "view"                    -- 跳转选项
-- opt.spelllang = { "en" }                    -- 拼写检查语言


-- ============================================================================
-- 消息和通知设置
-- ============================================================================
-- shortmess 选项说明:
-- a: 启用所有缩写 (l+m+r+w) - "999L,888B", "[+]", "[RO]", "[w]"
-- o: 覆盖文件写入后的读取消息 (减少 :wn 和 autowrite 重复消息)
-- O: 读取文件消息覆盖之前的消息 (减少消息堆积)
-- s: 不显示搜索命中底部/顶部的消息
-- t: 截断过长的文件消息
-- T: 截断过长的其他消息
-- W: 不显示文件写入时的消息 "[w]" 和 "[a]"
-- I: 不显示启动时的介绍信息
-- c: 不显示补全菜单中的消息
-- C: 不显示扫描补全项时的消息 ("scanning tags")
-- F: 不显示文件信息 (如保存时的行数统计)
-- S: 不显示搜索统计信息 ("[1/5]")
opt.shortmess:append("aoOstTWIcCFS")

-- stylua: ignore end

-- ============================================================================
-- SSH环境下的剪贴板支持
-- ============================================================================
-- 定义粘贴函数，用于SSH环境
local function paste()
  return {
    vim.fn.split(vim.fn.getreg(""), "\n"),
    vim.fn.getregtype(""),
  }
end

-- 如果在SSH环境中，使用OSC52协议进行剪贴板同步
if vim.env.SSH_TTY then
  vim.g.clipboard = {
    name = "OSC52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = paste,
      ["*"] = paste,
    },
  }
end

if vim.fn.exists("syntax_on") ~= 1 then vim.cmd("syntax enable") end

vim.filetype.add({
  pattern = {
    [".*/kitty/.+%.conf"] = "kitty",
    [".*/ghostty/config"] = "ghostty",
    ["%.env%.[%w_.-]+"] = "sh",
  },
})
vim.treesitter.language.register("bash", "kitty")
vim.treesitter.language.register("bash", "ghostty")
