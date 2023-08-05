local config = require("move.config")
local move_hor = require("move.horizontal")
local move_vert = require("move.vertical")
local M = {}

M.setup = function(opts)
  P("Setting up move.nvim")
	opts = vim.tbl_deep_extend("force", config.defaults, opts or {})
	if opts.load_commands then require("move.commands").load_commands() end
end

-- M = vim.tbl_deep_extend("force", M, {
-- 	MoveLine = move_vert.moveLine,
-- 	MoveBlock = move_vert.moveBlock,
-- 	MoveHChar = move_hor.horzChar,
-- 	MoveHBlock = move_hor.horzBlock,
-- 	MoveWord = move_hor.horzWord,
-- })
M.MoveLine = move_vert.move_line
M.MoveBlock = move_vert.move_block
M.MoveHChar = move_hor.horz_char
M.MoveHBlock = move_hor.horz_block
M.MoveWord = move_hor.horz_word
return M
