local U = require("move.utils")

local M = {}

M.insideFold = false
M.foldLastLine = -1

---Moves up or down the current cursor-line, mantaining the cursor over the line.
---@param dir number Movement direction. One of -1, 1.
M.move_line = function(dir)
	-- Get the last line of current buffer
	local last_line = vim.fn.line("$")

	-- Get current cursor position
	local cursor_position = vim.api.nvim_win_get_cursor(0)
	local line = cursor_position[1]

	if dir == nil then
		error("Missing offset", 3)
	end

	-- Edges
	if line == 1 and dir < 0 then
		return
	end
	if line == last_line and dir > 0 then
		return
	end

	-- General Case
	if line >= 1 and line <= last_line then
		local target = line
		local fold = U.calc_fold(line, dir)

		if fold ~= -1 then
			target = fold
		end

		local amount = U.calc_indent(target + dir, dir)
		U.swap_line(line, target + dir)
		U.indent(amount, target + dir)
	end
end

---Moves up or down a visual area mantaining the selection.
---@param dir number Movement direction. One of -1, 1.
---@param line1 number Initial line of the selected area.
---@param line2 number End line of the selected area.
M.move_block = function(dir, line1, line2)
	local vsrow = line1 or vim.fn.line("v")
	local verow = line2 or vim.api.nvim_win_get_cursor(0)[1]
	local last_line = vim.fn.line("$")
	local fold_expr = vim.wo.foldexpr

	-- Zero-based and end exclusive
	vsrow = vsrow - 1

	if vsrow > verow then
		local aux = vsrow
		vsrow = verow
		verow = aux
	end

	-- Edges
	if vsrow == 0 and dir < 0 then
		vim.api.nvim_exec(":normal! " .. vsrow .. "ggV" .. verow .. "gg", false)
		return
	end
	if verow == last_line and dir > 0 then
		vim.api.nvim_exec(
			":normal! " .. (vsrow + 1) .. "ggV" .. (verow + dir) .. "gg",
			false
		)
		return
	end

	local vBlock = vim.api.nvim_buf_get_lines(0, vsrow, verow, true)

	if dir < 0 then
		local vTarget = U.get_target(vsrow - 1, vsrow)
		table.insert(vBlock, vTarget[1])
	elseif dir > 0 then
		local vTarget = U.get_target(verow, verow + 1)
		table.insert(vBlock, 1, vTarget[1])
	end

	local amount = U.calc_indent((dir > 0 and verow or vsrow + 1) + dir, dir)
	U.move_range(
		vBlock,
		(dir > 0 and vsrow or vsrow - 1),
		(dir > 0 and verow + 1 or verow)
	)

	-- nvim_treesitter power folding is very experimental
	if fold_expr == "nvim_treesitter#foldexpr()" then
		-- Update folds in case of abnormal functionality
		vim.cmd(":normal! zx")
	end

	U.indent_block(amount, (dir > 0 and vsrow + 2 or vsrow), verow + dir)
	U.reselect_block(dir, vsrow, verow)
end

return M
