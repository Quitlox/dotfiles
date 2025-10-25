-- +---------------------------------------------------------+
-- | Chafa Output Caching Utility                            |
-- +---------------------------------------------------------+
--
-- This module provides caching functionality for chafa terminal output.
-- It caches the raw terminal output (ANSI sequences) to avoid regenerating
-- the image on every dashboard load.

local M = {}

--- Get the cache directory for chafa outputs
---@return string
local function get_cache_dir()
	local cache_home = vim.fn.stdpath("cache")
	local chafa_cache_dir = cache_home .. "/chafa"

	-- Create cache directory if it doesn't exist
	if vim.fn.isdirectory(chafa_cache_dir) == 0 then
		vim.fn.mkdir(chafa_cache_dir, "p")
	end

	return chafa_cache_dir
end

--- Generate a cache key from the command and image path
---@param cmd string The chafa command
---@return string The cache filename
local function get_cache_key(cmd)
	-- Extract the image path from the command
	local image_path = cmd:match("chafa%s+([^%s]+)")
	if not image_path then
		-- Fallback: use hash of entire command
		return vim.fn.sha256(cmd) .. ".cache"
	end

	-- Expand the path to handle ~ and relative paths
	image_path = vim.fn.expand(image_path)

	-- Get the absolute path and modification time
	local abs_path = vim.fn.fnamemodify(image_path, ":p")
	local mtime = vim.fn.getftime(abs_path)

	-- Create a unique cache key based on path, mtime, and command options
	local cache_key = abs_path .. "|" .. mtime .. "|" .. cmd
	local hash = vim.fn.sha256(cache_key)

	return hash .. ".cache"
end

--- Read cached output if it exists and is valid
---@param cmd string The chafa command
---@return string? cached_output The cached output, or nil if not found/invalid
local function read_cache(cmd)
	local cache_dir = get_cache_dir()
	local cache_file = cache_dir .. "/" .. get_cache_key(cmd)

	if vim.fn.filereadable(cache_file) == 1 then
		local content = vim.fn.readfile(cache_file)
		return table.concat(content, "\n")
	end

	return nil
end

--- Write output to cache
---@param cmd string The chafa command
---@param output string The command output to cache
local function write_cache(cmd, output)
	local cache_dir = get_cache_dir()
	local cache_file = cache_dir .. "/" .. get_cache_key(cmd)

	-- Write the output to the cache file
	local lines = vim.split(output, "\n")
	vim.fn.writefile(lines, cache_file)
end

--- Execute chafa command and cache the output
---@param cmd string The chafa command to execute
---@return string output The command output
local function execute_and_cache(cmd)
	-- Execute the command synchronously
	local handle = io.popen(cmd .. " 2>&1")
	if not handle then
		return "Error: Failed to execute chafa command"
	end

	local output = handle:read("*a")
	handle:close()

	-- Cache the output
	write_cache(cmd, output)

	return output
end

--- Get chafa output, using cache if available
---@param cmd string The chafa command to execute
---@return string output The command output (from cache or fresh execution)
function M.get_output(cmd)
	-- Try to read from cache first
	local cached = read_cache(cmd)
	if cached then
		return cached
	end

	-- If not in cache, execute and cache
	return execute_and_cache(cmd)
end

--- Clear all cached chafa outputs
function M.clear_cache()
	local cache_dir = get_cache_dir()
	local cache_files = vim.fn.globpath(cache_dir, "*.cache", false, true)

	for _, file in ipairs(cache_files) do
		vim.fn.delete(file)
	end

	vim.notify("Cleared " .. #cache_files .. " chafa cache file(s)", vim.log.levels.INFO)
end

--- Clear a specific cached output
---@param cmd string The chafa command whose cache to clear
function M.clear_cache_for(cmd)
	local cache_dir = get_cache_dir()
	local cache_file = cache_dir .. "/" .. get_cache_key(cmd)

	if vim.fn.filereadable(cache_file) == 1 then
		vim.fn.delete(cache_file)
		vim.notify("Cleared cache for: " .. cmd, vim.log.levels.INFO)
	end
end

--- Get a command that outputs cached chafa content for use in terminal sections
--- This function gets/generates the cached chafa output and writes it to a temporary file,
--- then returns a cat command that can be used in a snacks terminal section to properly
--- render the ANSI escape sequences.
---@param cmd string The chafa command to execute and cache
---@return string shell_cmd A shell command that outputs the cached content
function M.get_cached_terminal_cmd(cmd)
	local cache_dir = get_cache_dir()

	-- Get the cached output (this will execute and cache if needed)
	local output = M.get_output(cmd)

	-- Write to a temporary file with the cached output
	local temp_output = cache_dir .. "/current_image.txt"
	local file = io.open(temp_output, "w")
	if file then
		file:write(output)
		file:close()
	end

	-- Return a command that just cats the cached file
	return "cat " .. vim.fn.shellescape(temp_output) .. "; sleep .1"
end

return M
