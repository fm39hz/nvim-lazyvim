local function createLogo(withBorder)
	local lines = {
		"                                ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆                                   ",
		"                                 ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦                                ",
		"                                       ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄                              ",
		"                                        ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄                             ",
		"                                       ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀                            ",
		"                                ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄                           ",
		"   ███▄    █ ▓█████  ▒█████    ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄    ██▒   █▓ ██▓ ███▄ ▄███▓ ",
		"   ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒ ⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  ▓██░   █▒▓██▒▓██▒▀█▀ ██▒ ",
		"  ▓██  ▀█ ██▒▒███   ▒██░  ██▒ ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄  ▓██  █▒░▒██▒▓██    ▓██░ ",
		"  ▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░      ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆       ▒██ █░░░██░▒██    ▒██  ",
		"  ▒██░   ▓██░░▒████▒░ ████▓▒░       ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃        ▒▀█░  ░██░▒██▒   ░██▒ ",
		"   ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ╰──────────────────────────────╯    ░ ▐░  ░▓  ░ ▒░   ░  ░ ",
		"   ░░   ░ ▒░ ░ ░  ░  ░ ▒ ▒░                                        ░ ░░   ▒ ░░  ░      ░ ",
		"    ░   ░ ░    ░   ░ ░ ░ ▒                                           ░░   ▒ ░░      ░    ",
		"          ░    ░  ░    ░ ░                                            ░   ░         ░    ",
		"                                                                     ░                   ",
	}

	if withBorder then
		local result =
			"╭─────────────────────────────────────────────────────────────────────────────────────────╮\n"
		for _, line in ipairs(lines) do
			result = result .. "│" .. line .. "│\n"
		end
		result = result
			.. "╰─────────────────────────────────────────────────────────────────────────────────────────╯"
		return result
	else
		return table.concat(lines, "\n")
	end
end

local logo = createLogo(false)
return {
	{
		"folke/snacks.nvim",
		opts = {
			image = {
				force = true,
			},
			quickfile = {},
			scroll = {},
			statuscolumn = {},
			words = {},
			input = {},
			lazygit = {
				win = {
					style = "lazygit",
					border = "none",
					width = 130,
					height = 32,
					row = 2,
				},
			},
			dashboard = {
				preset = {
					header = logo,
				},
				sections = {
					{ section = "header" },
					{ icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
					{ section = "startup" },
				},
			},
			terminal = {
				win = {
					style = "terminal",
					position = "float",
					border = "rounded",
					width = 128,
					height = 16,
					row = 1,
					title_pos = "top",
				},
				interactive = true,
			},
		},
		keys = {
			{
				"<C-/>",
				function()
					Snacks.terminal.toggle()
				end,
				desc = "Toggle Terminal",
			},
			{
				"<C-_>",
				function()
					Snacks.terminal.toggle()
				end,
				desc = "Toggle Terminal",
			},
		},
	},
}
