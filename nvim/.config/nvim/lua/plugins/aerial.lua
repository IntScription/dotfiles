return {
  {
    "stevearc/aerial.nvim",
    opts = {
      backends = { "treesitter", "lsp", "markdown", "asciidoc", "man" },

      layout = {
        default_direction = "right",
        min_width = 20,
        max_width = 28,
        resize_to_content = true,
      },

      attach_mode = "window",
      close_on_select = true,
      highlight_on_hover = true,
      show_guides = true,

      -- Main behavior you wanted:
      -- moving in Aerial makes the source window follow
      autojump = true,

      guides = {
        mid_item = "├─",
        last_item = "└─",
        nested_top = "│ ",
        whitespace = "  ",
      },

      filter_kind = {
        "Class",
        "Constructor",
        "Enum",
        "Function",
        "Interface",
        "Method",
        "Module",
        "Namespace",
        "Package",
        "Struct",
        "Component",
      },

      float = {
        border = "rounded",
      },

      -- Simplified sidebar-only keymaps
      keymaps = {
        ["?"] = "actions.show_help",
        ["<CR>"] = "actions.jump",
        ["o"] = "actions.jump",
        ["q"] = "actions.close",
        ["j"] = "actions.down_and_scroll",
        ["k"] = "actions.up_and_scroll",
      },
    },

    keys = {
      { "<leader>cs", "<cmd>AerialToggle!<CR>", desc = "Code Structure" },
      { "]a", "<cmd>AerialNext<CR>", desc = "Next Symbol" },
      { "[a", "<cmd>AerialPrev<CR>", desc = "Prev Symbol" },
    },
  },
}
