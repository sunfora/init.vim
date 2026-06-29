-- isntead of opening file in telescope alone we should create and register a protocol
-- it should use current worktree and open files as :edit timemachine://<hash>/<path>
-- or open a file browser if it is a dir like :edit timemachine://<hash>
--
-- this is basically it but it should be not strictly and edit command
-- it should work with LSP and gf, gd whatever low-level shit
--
-- as if it was a true protocol
-- all read only no write

local time_machine_group = vim.api.nvim_create_augroup("TimeMachine", {})


vim.api.nvim_create_user_command('TimeMachine', function()
  local current_window = 0

  -- save bunch of metadata about the original file
  local original_filetype  = vim.bo.filetype
  local original_buf       = vim.api.nvim_win_get_buf(current_window)

  local current_file_path  = vim.fn.expand('%:p')
  local maybe_buf_set_path = vim.b[original_buf].time_machine_path

  if maybe_buf_set_path ~= nil then
    current_file_path = maybe_buf_set_path
  end

  -- then extract from git the history/mapping between each commit and
  -- the corresponding filename even if it was renamed in a process
  local shell_safe_current_file = vim.fn.shellescape(current_file_path)
  local historic_names_data = vim.fn.systemlist(
    'git log --follow --name-only --pretty=format:"%h" -- ' .. shell_safe_current_file
  )

  if vim.tbl_isempty(historic_names_data) then
    vim.notify("Current file is not tracked by Git", vim.log.levels.ERROR)
    return
  end
  
  assert(
    (#historic_names_data + 1) % 3 == 0, 
    "git log returned incorrect number of lines"
  )

  local data = {}
  
  for i = 1,#historic_names_data,3 do
    local hash_id    = i
    local name_id    = i + 1
    
    local hash = historic_names_data[hash_id]
    local name = historic_names_data[name_id]

    data[hash] = name
  end
  
  local telescope_actions       = require('telescope.actions')
  local telescope_actions_state = require('telescope.actions.state')

  -- we use git commits
  -- since we need to provide a custom command to the telescope picker
  require('telescope.builtin').git_commits({
    prompt_title = "Time Machine",
    git_command = { "git", "log", "--follow", "--pretty=oneline", "--abbrev-commit", "--", current_file_path },
    attach_mappings = function(prompt_bufnr, map)
      
      -- this function would run when you has selected an entry in picker
      local open_safely = function()
        -- read the commit hash
        local entry = telescope_actions_state.get_selected_entry()
        local commit = entry.value
        telescope_actions.close(prompt_bufnr)
        
        -- find out which file it was
        local hash_relative_file = data[commit]
        local shes_hash_relative_file = vim.fn.shellescape(hash_relative_file)
        
        -- get the data
        local cmd     = string.format('git show %s:%s', commit, shes_hash_relative_file)
        local content = vim.fn.systemlist(cmd)
        
        -- and create a buffer
        local buflisted      = false
        local scratch        = false
         
        local start_line     = 0
        local end_line       = -1
        local strict         = false

        local scratch_buf = vim.api.nvim_create_buf(buflisted, scratch)

        vim.api.nvim_buf_set_lines(
          scratch_buf, 
          start_line, end_line, strict, 
          content
        )
        
        vim.api.nvim_win_set_buf(current_window, scratch_buf)
        
        -- we use only current_file_path now, and hash is curently unused thing
        -- I might need it in the future though so let it be here
        vim.b[scratch_buf].time_machine_commit = commit 
        vim.b[scratch_buf].time_machine_path   = current_file_path

        -- disable lsp
        vim.b[scratch_buf].lsp_auto_enable = false

        vim.bo[scratch_buf].filetype   = original_filetype
        vim.bo[scratch_buf].buftype    = 'nofile'
        vim.bo[scratch_buf].bufhidden  = 'wipe'
        vim.bo[scratch_buf].modifiable = false
        vim.bo[scratch_buf].readonly   = true

        
        local window_title = string.format(
          "timemachine://%s/%s", commit, hash_relative_file
        )
        vim.api.nvim_buf_set_name(scratch_buf, window_title)
      end

      -- here just map the key Enter in both modes
      map('i', '<CR>', open_safely)
      map('n', '<CR>', open_safely)
      return true
    end
  })
end, { desc = "Browse file history safely in a read-only scratch buffer" })
