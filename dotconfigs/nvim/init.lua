-- This file simply bootstraps the installation of Lazy.nvim and then calls other files for execution
-- This file doesn't necessarily need to be touched, BE CAUTIOUS editing this file and proceed at your own risk.
local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- validate that lazy is available
if not pcall(require, "lazy") then
  -- stylua: ignore
  vim.api.nvim_echo({ { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } }, true, {})
  vim.fn.getchar()
  vim.cmd.quit()
end

require "lazy_setup"
require "polish"

-- Load AstroNvim
require("astronvim").setup()

-- -- Load user configurations
-- require("user.init")

------------
-- CUSTOM --
------------

-- DAP setup for JS, TS files

-- local dap = require "dap"

-- Set up the debug adapter
-- require("dap").adapters["pwa-node"] = {
--   type = "server",
--   host = "localhost",
--   port = "${port}",
--   executable = {
--     command = "node",
--     args = {
--       require("mason-registry").get_package("js-debug-adapter"):get_install_path() .. "/js-debug/src/dapDebugServer.js",
--       "${port}",
--     },
--   },
-- }

-- Add JavaScript configurations
-- require("dap").configurations.javascript = {
--   {
--     type = "pwa-node",
--     request = "launch",
--     name = "Launch file",
--     program = "${file}",
--     cwd = "${workspaceFolder}",
--   },
--   {
--     type = "pwa-node",
--     request = "attach",
--     name = "Attach",
--     processId = require("dap.utils").pick_process,
--     cwd = "${workspaceFolder}",
--   },
-- }

-- Also add TypeScript configurations
-- require("dap").configurations.typescript = require("dap").configurations.javascript

-- Load custom keybindings
local mappings = require "mappings"
for mode, mode_mappings in pairs(mappings) do
  for lhs, mapping in pairs(mode_mappings) do
    local rhs = mapping[1]
    local opts = { noremap = true, silent = true, desc = mapping.desc }
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
  end
end

--------------------
-- CUSTOM MACROS -- 
--------------------

-- Macro for console.log("<text> :", <text>);
local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)

-- Macro for console.log()
vim.fn.setreg("l", "yoconsole.log('" .. esc .. "pa:', " .. esc .. "pa);" .. esc .. "s") -- with save
-- vim.fn.setreg("l", "yoconsole.log('" .. esc .. "pa :', " .. esc .. "pa);" .. esc .. "") -- without save

-- Macro for console.log()
-- Only apply to TS & JS files 
-- vim.api.nvim_create_augroup("JSLogMacro", { clear = true })
--
-- vim.api.nvim_create_autocmd("FileType", {
--   group = "JSLogMacro",
--   pattern = { "javascript", "typescript" }, -- only trigger for .js, .ts filetypes
--   callback = function()
--     vim.fn.setreg("l", "yoconsole.log('" .. esc .. "pa :', " .. esc .. "pa);" .. esc .. "") -- without save
--     -- vim.fn.setreg("l", "yoconsole.log('" .. esc .. "pa :', " .. esc .. "pa);" .. esc .. "s") -- with save
--   end,
-- })

