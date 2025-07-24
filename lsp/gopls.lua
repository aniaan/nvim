return {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl", "gosum" },
  root_markers = { "go.mod", "go.work" },
  settings = {
    gopls = {
      gofumpt = true,
      directoryFilters = {
        "-.git",
        "-.vscode",
        "-.idea",
        "-.vscode-test",
        "-node_modules",
        "-__pycache__",
        "-.venv",
        "-venv",
        "-target",
        "-build",
        "-dist",
      },
      hints = {
        assignVariableTypes = true, -- 为变量赋值添加类型提示
        compositeLiteralFields = true, -- 为复合字面量字段添加提示
        compositeLiteralTypes = true, -- 为复合字面量类型添加提示
        constantValues = true, -- 为常量显示值
        functionTypeParameters = true, -- 显示函数的类型参数
        parameterNames = true, -- 在调用处显示参数名
        rangeVariableTypes = true, -- 显示 range 变量的类型
      },
      analyses = {
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
      },
      usePlaceholders = true,
      completeUnimported = true,
      semanticTokens = true,
    },
  },
}
