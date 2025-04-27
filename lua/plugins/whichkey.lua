return
{
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts ={

  },
  config = function (_, opts)
  	require("which-key").setup(opts)
  end,
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
