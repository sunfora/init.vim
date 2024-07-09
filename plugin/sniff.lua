if (_G.sniff) then
  error("Sniff: global name clash")  
end

_G.sniff = {}

local newline = (vim.fn.has("win32") == 1) and "\r\n" 
                                           or  "\n"

function sniff:terminal()
  if (not vim.b.terminal_job_id) then
    vim.api.nvim_err_writeln("Sniff: not a terminal")
    return false
  end
  self.job = vim.b.terminal_job_id
  vim.cmd([[echo "Sniff: connected ]] .. self.job .. '"')
  return true
end

function sniff:send(text)
  if (not self.job) then
    vim.api.nvim_err_writeln("Sniff: no job selected")
    return false 
  end
  vim.fn.chansend(self.job, text)
  return true
end

function sniff:sendln(text)
  sniff:send(text .. newline)
end
