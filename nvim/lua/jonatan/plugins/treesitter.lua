local treesitter_status, treesitter = pcall(require, "nvim-treesitter.configs")
if not treesitter_status then return end

treesitter.setup({
  ensure_installed = {
    "lua",
    "javascript",
    "go",
    "json",
    "yaml",
    "typescript",
    "markdown",
    "html",
    "java",
    "gitignore",
    "gitattributes",
    "dockerfile"
  },

  auto_install = true,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,
  },

  indent = { enable = true },

  autotag = { enable = true },
})
