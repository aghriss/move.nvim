local M = {}

M.load_commands = function()
  P("Loading move.nvim")
	local move_hor = require("move.horizontal")
	local move_vert = require("move.vertical")
	local cpo = vim.opt.cpoptions
	vim.cmd("set cpo&vim")

	vim.api.nvim_create_user_command("MoveLine", function(args)
		local dir = tonumber(args.args:gsub("[()]", ""), 10)
		move_vert.move_line(dir)
	end, { desc = "Move cursor line", force = true, nargs = 1 })

	vim.api.nvim_create_user_command("MoveBlock", function(args)
    P(args)
		local dir = tonumber(args.args:gsub("[()]", ""), 10)
		move_vert.move_block(dir, args.line1, args.line2)
	end, { desc = "Move visual block", force = true, nargs = 1, range = "%" })

	vim.api.nvim_create_user_command("MoveHChar", function(args)
		local dir = tonumber(args.args:gsub("[()]", ""), 10)
		move_hor.horz_char(dir)
	end, {
		desc = "Move the character under the cursor horizontally",
		force = true,
		nargs = 1,
	})

	vim.api.nvim_create_user_command("MoveHBlock", function(args)
		local dir = tonumber(args.args:gsub("[()]", ""), 10)
		move_hor.horz_block(dir)
	end, {
		desc = "Move visual block horizontally",
		force = true,
		nargs = 1,
		range = "%",
	})

	vim.api.nvim_create_user_command("MoveWord", function(args)
		local dir = tonumber(args.args:gsub("[()]", ""), 10)
		move_hor.horz_word(dir)
	end, { desc = "Move word forwards or backwards", force = true, nargs = 1 })

	vim.opt.cpoptions = cpo

	vim.g.move_nvim_loaded = true
end

return M
