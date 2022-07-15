local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local builtin = require("telescope.builtin")
local scan = require("plenary.scandir")

local M = {}

local getFolders = function(folders, ownerfile, owner)
	local services = {}
	local owner_set = {}
	for line in io.lines(ownerfile) do
		local found = string.find(line, owner)
		if found then
			local split = vim.split(vim.split(line, " ")[1], "/")
			owner_set[split[#split]] = true
		end
	end
	for _, folder in pairs(folders) do
		local find_command = {
			"fd",
		}
		if folder.filetypes then
			for _, filetype in pairs(folder.filetypes) do
				table.insert(find_command, "-e")
				table.insert(find_command, filetype)
			end
		end

		local dirs = scan.scan_dir(folder.path, { depth = 1, only_dirs = true })
		for _, dir in pairs(dirs) do
			local segments = vim.split(dir, "/")
			if folder.owner == nil then
				table.insert(services, {
					title = segments[#segments],
					path = dir,
					find_command = find_command,
				})
			end
			if folder.owner then
				if owner_set[segments[#segments]] then
					table.insert(services, {
						title = segments[#segments],
						path = dir,
						find_command = find_command,
					})
				end
			end
		end
	end
	return services
end

M.setup = function(opts)
	M._folders = getFolders(opts.folders, opts.ownerfile, opts.owner)
end

M.folders = function(opts)
	opts = opts or {}
	pickers.new(opts, {
		prompt_title = "folders",
		finder = finders.new_table({
			results = M._folders,
			entry_maker = function(service)
				return {
					value = service,
					display = service.title,
					ordinal = service.title,
				}
			end,
		}),
		sorter = conf.generic_sorter(opts),
		attach_mappings = function(prompt_bufnr, _)
			actions.select_default:replace(function()
				local value = action_state.get_selected_entry(prompt_bufnr).value
				vim.fn.execute("cd " .. value.path, "silent")
				vim.schedule(function()
					builtin.find_files({
						cwd = value.path,
						find_command = value.find_command,
					})
				end)
			end)
			return true
		end,
	}):find()
end

return M
