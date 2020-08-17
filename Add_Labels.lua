-- VECTRIC LUA SCRIPT

------------------------ Global Variables --------------------------------------------------

-- Dialog variables
g_title = "Label Maker"
g_version = "1.0" -- ONLY RECTANGLE SUPPORT.

------------------------ Event Listeners ---------------------------------------------------

-------------------------------------
----- SAVE LABEL BUTTON LISTENER-----
-------------------------------------
function OnLuaButton_SaveLabel(dialog)
  
  selected_item:SetString("label", dialog:GetTextField("ItemLabel"))
  dialog:AddDropDownListValue("ItemList", "new1")

  return true
end

----------------------------------
----- ITEM DROP DOWN LISTENER-----
----------------------------------
function OnLuaSelector_ItemList(dialog)

  job.LayerManager:GetAt(job.LayerManager:GetHeadPosition()):RemoveObject(current_item_marker)
  job:Refresh2DView()

  local selected_item_id = string.match(dialog:GetDropDownListValue("ItemList"), "'(.*)'")
  
  -- Get the CadObject currently selected in the dropdown list.
  local pos = job.Selection:GetHeadPosition()
  while pos ~= nil do
    item, pos = job.Selection:GetNext(pos)
    if item.Id == selected_item_id then
      selected_item = item
    end
  end

  -- Update the label text field with current item label.
  if selected_item:ParameterExists("label", ParameterList.UTP_STRING) then
    item_label = selected_item:GetString("label", "none", false)
    dialog:UpdateTextField("ItemLabel", item_label)
  else
    item_label = "NoLabel"
    dialog:UpdateTextField("ItemLabel", item_label)
  end

  -- Use a marker to show the currently selected item.
  current_item_marker = CadMarker(item_label, selected_item:GetBoundingBox().Centre, 5)
  job.LayerManager:GetAt(job.LayerManager:GetHeadPosition()):AddObject(current_item_marker, true)
  job:Refresh2DView()

  return true
end

------------------------ Utility Functions -------------------------------------------------

--------------------------------------
--Refresh items in the drop down list-
--------------------------------------
function refreshItemDropDownList(dialog)
  local pos = job.Selection:GetHeadPosition()
  while pos ~= nil do
    item, pos = job.Selection:GetNext(pos)
    
    -- If dealing with a rectangle.
    -- ONLY WORKS WITH RECTANGLES AT THE MOMENT.
    if item.ClassName == "vcCadPolyline" then

      -- Get the luaUUID for the item.
      item_id = item.Id

      -- Get rectangle dimensions.
      item_width = item:GetBoundingBox().XLength 
      item_length = item:GetBoundingBox().YLength

      -- Check if item already has a label.
      item_label = "Rectangle"
      --if item:ParameterExists("label", ParameterList.UTP_STRING) then
        --item_label = item:GetString("label", "none", false)
      --else
        --item_label = "No Label"
      --end
    
      -- Concatenate the full value for the item in the dropdown list.
      dropdown_name = item_label .. ", " .. item_width .. " x " .. item_length .. ", " .. "'" .. item_id .. "'"

      -- Add the full item description to the dropdown list.
      dialog:AddDropDownListValue("ItemList", dropdown_name)
    end
  end
end

-----------------------------------
-- OPENS A CUSTOM HTML DIALOG BOX--
-----------------------------------
function addLabelsDialog(filename, name, h, w, selected_items)
  local dialog = HTML_Dialog(false, "file:" ..filepath.."\\" ..filename.. ".htm", h, w, name)
  
  -- Add dialog HTML features.
  dialog:AddLabelField("GadgetTitle", g_title)
  dialog:AddDropDownList("ItemList", "Item List")
  dialog:AddTextField("ItemLabel", "Item Label")


  -- Add all selected items into the dropdown menu.
  refreshItemDropDownList(dialog)

  dialog:ShowDialog()

  return dialog
end

--- MAIN FLOW ---

function main(path)
  job = VectricJob()
  
  -- If no job open, throw error.
  if not job.Exists then
    DisplayMessageBox("No job loaded.")
    return false;
  end
  
  filepath = path

  -- Gets the list of selected CadObjects.
  selected_items = job.Selection

  -- Creates the "Add Labels" dialog.
  addlabels_dialog = addLabelsDialog("AddLabels_dialog", "Add Labels", 500, 500, selected_items)

  -- Remove leftover markers.
  job.LayerManager:GetAt(job.LayerManager:GetHeadPosition()):RemoveObject(current_item_marker)
  job:Refresh2DView()

  return true
end
  