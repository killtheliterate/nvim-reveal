local function reveal()
  -- @TODO: Make this work on macOS and Windows
  local sysname = vim.loop.os_uname().sysname

  local currentBuffer = vim.api.nvim_get_current_buf()
  local bufName = vim.api.nvim_buf_get_name(currentBuffer)
  local ftype = vim.fn.getftype(bufName)

  local open_cmd
  if sysname == "Darwin" then
    open_cmd = "open"
  elseif sysname == "Windows_NT" then
    open_cmd = "start"
  else
    open_cmd = "xdg-open"
  end

  if ftype == "dir" then
    os.execute(open_cmd .. " " .. bufName)
  else
    os.execute(open_cmd .. " " .. vim.fn.expand("%:p:h"))
  end
end

local Config = {
  trigger_key = "<leader>R"
}

local function setup(options)
  local trigger_key
  if options.trigger_key == nil then
    trigger_key = Config.trigger_key
  else
    trigger_key = options.trigger_key
  end

  vim.api.nvim_create_user_command(
    "Reveal",
    function()
      reveal()
    end,
    { desc = "xdg-open" }
  )

  vim.keymap.set("n", trigger_key, ":Reveal<CR>", { noremap = true, desc = "[R]eveal with xdg-open" })
end

return {
  reveal = reveal,
  setup = setup,
}
