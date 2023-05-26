local cmp_wk_status, cmp_wk = pcall(require, "which-key")
if not cmp_wk_status then return end

local mappings = {}
cmp_wk.register(mappings)

cmp_wk.setup{}
