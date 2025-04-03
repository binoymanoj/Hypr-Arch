return {
  n = {
    ["<C-y>"] = { "ggVG", desc = "Select entire buffer" },
    ["<Leader><Tab>"] = { ":bnext<CR>", desc = "Next buffer" },
    ["YF"] = { "va{Vy", desc = "Select entire function" },
    ["s"] = { ":w<CR>", desc = "Save file" },
  },
  v = {
    ["<M-j>"] = { ":m '>+1<CR>gv=gv", desc = "Move selection down" },
    ["<M-k>"] = { ":m '<-2<CR>gv=gv", desc = "Move selection up" },
  },
  i = {
    ["<M-j>"] = { "<Esc>:m .+1<CR>==gi", desc = "Move line down" },
    ["<M-k>"] = { "<Esc>:m .-2<CR>==gi", desc = "Move line up" },
  },
}

