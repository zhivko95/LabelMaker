-- VECTRIC LUA SCRIPT
--- MAIN FLOW ---

function main(path)
  job = VectricJob()
    
  -- If no job open, throw error.
  if not job.Exists then
    DisplayMessageBox("No job loaded.")
    return false;
  end
  
  -- Store all CadObject labels in a text file.
  local labels = ""
  local pos = job.Selection:GetHeadPosition()
  while pos ~= nil do
    item, pos = job.Selection:GetNext(pos)
    if item:ParameterExists("label", ParameterList.UTP_STRING) then
      labels = labels .. item:GetString("label", "none", false) .. ","
    else
      labels = labels .. "NoLabel,"
    end
  end

  -- Run a python script to print all of the labels.
  local pyfile = io.popen('py "' .. path .. '\\print_labels.py" --labels ' .. labels)

  return true
end