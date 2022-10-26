local cmp_autopairs_status, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
if not cmp_autopairs_status then return end

local cmp_status, cmp = pcall(require, "cmp")
if not cmp_status then return end

local luasnip_status, luasnip = pcall(require, "luasnip")
if not luasnip_status then return end

local lspkind_status, lspkind = pcall(require, "lspkind")
if not lspkind_status then return end

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  window = {},
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol',
      maxwidth = 50,
      ellipsis_char = '...',
      before = function (entry, vim_item)
        return vim_item
      end
    })
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.abort(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' }, -- lsp
    { name = 'luasnip' }, -- snippets
    { name = 'buffer' }, -- text within current buffer
    { name = 'path'}, -- file system paths
  })
})
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)
