local consts = require("consts")
return {
  {
    consts.AVANTE,
    event = "VeryLazy",
    enabled = false,
    version = false, -- set this if you want to always pull the latest change
    build = "make",
    dependencies = {
      consts.PLENARY,
      consts.NUI,
      consts.MARKDOWN,
    },
    dir = "~/workspace/github/avante.nvim",
    opts = {
      windows = {
        position = "left",
        ask = {
          start_insert = false,
        },
      },
      hints = {
        enabled = false,
      },
      selector = {
        provider = "snacks",
      },
      input = {
        provider = "snacks",
        provider_opts = {
          title = "Avante Input",
          icon = " ",
          placeholder = "Enter your API key...",
        },
      },
      behaviour = {
        enable_token_counting = false,
        enable_fastapply = true,
      },
      provider = "openai",
      providers = {
        openai = {
          endpoint = "https://openrouter.ai/api/v1",
          model = "moonshotai/kimi-k2",
          use_ReAct_prompt = true,
          extra_request_body = {
            -- temperature = 0.75,
            max_tokens = 32768,
            allow_fallbacks = false,
            only = { "moonshotai" },
          },
        },
      },
    },
  },
}
