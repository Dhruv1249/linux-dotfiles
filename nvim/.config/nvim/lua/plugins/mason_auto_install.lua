return{
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = { "williamboman/mason.nvim" },

  config = function()
    require("mason-tool-installer").setup({
      ensure_installed = {
        -- Formatters
        "stylua",
        "prettier",
        "black",
        "isort",
        "shfmt",
        "rustfmt",
        "terraform",

        -- Linters (optional)
        "eslint_d",
        "pylint",
      },

      run_on_start = true,
    })
  end,
}
