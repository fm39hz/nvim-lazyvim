-- 1. Tách function xử lý logic ra đầu file
local function render_and_open_puml(callback)
	local bufnr = vim.api.nvim_get_current_buf()
	local content = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n")
	local hash = vim.fn.sha256(content):sub(1, 16)
	local tmp_dir = vim.fn.stdpath("cache") .. "/puml_cache/"

	if vim.fn.isdirectory(tmp_dir) == 0 then
		vim.fn.mkdir(tmp_dir, "p")
	end
	local tmp_path = tmp_dir .. hash .. ".png"

	-- Nếu đã có cache, mở luôn
	if vim.fn.filereadable(tmp_path) == 1 then
		callback(tmp_path)
		return
	end

	-- Nếu chưa có, xuất file mới
	vim.notify("Generating PlantUML...", vim.log.levels.INFO)
	vim.api.nvim_exec2("PlantumlExport png " .. tmp_path, {})

	-- Kiểm tra file ổn định (tránh race condition)
	local last_size = 0
	local stable_count = 0
	local timer = vim.uv.new_timer()

	timer:start(
		100,
		200,
		vim.schedule_wrap(function()
			local stats = vim.uv.fs_stat(tmp_path)
			if stats and stats.size > 0 then
				if stats.size == last_size then
					stable_count = stable_count + 1
				else
					last_size = stats.size
					stable_count = 0
				end

				if stable_count >= 2 then
					timer:stop()
					if not timer:is_closing() then
						timer:close()
					end
					callback(tmp_path)
				end
			end
		end)
	)
end
return {
	{
		"obsidian-nvim/obsidian.nvim",
		event = "BufReadPre " .. vim.fn.expand("~") .. "/Workspace/Notes/Obsidian/*/*.md",
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			legacy_commands = false,
			workspaces = {
				{
					name = "samsara",
					path = "~/Workspace/Notes/Obsidian/ProjectSamsara",
				},
			},
			notes_subdir = "notes",
			daily_notes = {
				folder = "notes/dailies",
				date_format = "%Y-%m-%d",
				alias_format = "%B %-d, %Y",
				default_tags = { "daily-notes" },
				template = nil,
				workdays_only = true,
			},
			completion = {
				nvim_cmp = false,
				blink = true,
				min_chars = 2,
			},
		},
	},
	{
		"jmbuhr/otter.nvim",
		ft = "markdown",
		dependencies = {
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{
		"goropikari/plantuml.nvim",
		dependencies = { "goropikari/LibDeflate.nvim" },
		ft = "plantuml",
		opts = {
			base_url = "https://www.plantuml.com/plantuml",
			reload_events = { "BufWritePre" },
		},
		keys = {
			{ "<leader>ps", "<cmd>PlantumlPreview ascii<cr>", desc = "Preview PlantUML (ASCII)" },
			{
				"<leader>po",
				function()
					render_and_open_puml(function(path)
						Snacks.win({
							file = path,
							width = 0.8,
							height = 0.8,
							wo = { winhighlight = "Normal:SnacksNormal" },
						})
					end)
				end,
				desc = "Preview PlantUML (Snacks)",
			},
			{
				"<leader>pO",
				function()
					render_and_open_puml(function(path)
						vim.fn.jobstart({ "nsxiv", "-b", path })
					end)
				end,
				desc = "Open PlantUML (nsxiv)",
			},
			{ "<leader>pe", ":PlantumlExport png ", desc = "Export PlantUML to path" },
		},
	},
}
