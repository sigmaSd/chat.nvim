local job_id
local ready = false

local function get_selection()
  local _, lineStart = unpack(vim.fn.getpos("'<"))
  local _, lineEnd = unpack(vim.fn.getpos("'>"))
  local lines = vim.fn.getline(lineStart, lineEnd)
  return table.concat(lines, "\n")
end

local function get_input()
  local input = ""
  vim.ui.input({ prompt = "> " }, function(inz)
    input = inz
  end)
  return input
end

local function write_line(lines)
  local buf = vim.api.nvim_get_current_buf()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(buf, row - 1, row - 1, false, lines)
end

local function chat_send(input)
  if job_id == nil then
    error("run ChatStart first")
    return
  end
  if not ready then
    error("connect chatGpt first")
    return
  end
  vim.fn.chansend(job_id, input .. '\n')
end

function ChatStart()
  local function on_stdout(_, data)
    -- chatGpt exited probably
    -- if data == { "" } then
    if #data == 1 and data[1] == "" then
      return
    end

    local resp = vim.trim(table.concat(data, '\n'))
    if ready then
      local to_write = { "--[[" }
      for word in resp:gmatch("[^\n]+") do
        table.insert(to_write, word)
      end
      table.insert(to_write, "]]--")
      write_line(to_write)
      print(resp)
      return
    end
    if resp == "waiting" then
      print("waiting for chatGpt connection")
    elseif resp == "ready" then
      print("chatGpt connected!")
      ready = true
    end
  end

  job_id = vim.fn.jobstart({ "deno", "run", "-A", "./chat.ts" }, {
    on_stdout = on_stdout,
  })
end

function ChatStop()
  if job_id == nil then
    print("already exited")
    return
  end
  vim.fn.jobstop(job_id)
end

function Chat()
  local selection = get_selection()
  local input = get_input()
  chat_send(input .. "\n" .. selection)
end

vim.api.nvim_create_user_command("ChatStart", ChatStart, {})
vim.api.nvim_create_user_command("Chat", Chat, { range = true })
vim.api.nvim_create_user_command("ChatStop", ChatStop, {})
