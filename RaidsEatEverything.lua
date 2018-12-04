SLASH_REE1 = "/ree"
SLASH_REE2 = "/raidseateverything"
BINDING_HEADER_KITTYONE = "RaidsEatEverything v0.1"

reeVersion = "|cffffffffv0.1 by |cff4c8affAreesto"
reeLocked = 0
local reeConsumableMax = 16

-- /ree commands
SlashCmdList["REE"] = function(message)
	local cmd = { }
	for c in string.gfind(message, "[^ ]+") do
		table.insert(cmd, string.lower(c))
	end

  if not cmd[1] then
    reePrint("syntax here")
  elseif cmd[1] == "options" then
    if (reeOptions:IsShown()) then
      reeOptions:Hide();
      reeLoadOptions();
    else
      reeOptions:Show();
      reeLoadOptions();
    end
  elseif cmd[1] == "scan" then
    reeScanBags()
  else
    reePrint("Unrecognized or incorrect syntax. Use /ree help for list of available commands.")
  end
end

-- loads options when opening
function reeLoadOptions()
  if reeLocked == 1 then
    checkBox(lockCheckbox)
  end
end

-- moves frame if not locked
function reeMoveFrame(frame)
  if (reeLocked == 0) then
    frame:StartMoving()
  end
end

-- removes tooltip after hover
function reeOffHover()
  GameTooltip:Hide()
end

-- uses consumable when clicked
function reeOnClick()
  reeUseItem(this:GetID())
	this:SetChecked(0)
end

function reeOnEvent()
  this:RegisterEvent("BAG_UPDATE")
  --reePrint("event happened: " ..event)
  if event == "BAG_UPDATE" then
    reeScanBags()
  end
end

-- displays tooltip when hovered over
function reeOnHover()
	local reeConsumeIndex = this:GetID()
  GameTooltip_SetDefaultAnchor( GameTooltip, UIParent )
	GameTooltip:SetBagItem(reeItems[reeConsumeIndex].bag,reeItems[reeConsumeIndex].slot)
 	GameTooltip:Show()
end

-- runs when addon is loaded
function reeOnLoad()
  reePrint(reeVersion.."|cffffffff loaded! |cff42e5f4/ree |cfffffffffor options - |cff4c8aff https://gitlab.com/areesto");
  -- register events
  --RaidsEatEverything = CreateFrame("Frame", nil)
  this:RegisterEvent("PLAYER_ENTERING_WORLD")

  reeScanBags()
end

--prints chat message
function reePrint(input_str)
  DEFAULT_CHAT_FRAME:AddMessage("|cff42e5f4RaidsEatEverything: |cffffffff"..input_str)
end

-- go through bags and store information in reeItems
function reeScanBags()
  reeItems = {}
  local idx,i,j,k,texture = 1
  local itemLink,itemID,itemName,itemCategory,itemTexture,itemIsDuplicate
  for i=0,4 do
    for j=1,GetContainerNumSlots(i) do
      itemLink = GetContainerItemLink(i,j)
      if itemLink then
        _,_,itemID,itemName = string.find(GetContainerItemLink(i,j) or "","item:(%d+).+%[(.+)%]")
        _,_,_,_,_,itemCategory,_,_,itemTexture = GetItemInfo(itemID or "")

        if itemCategory=="Consumable" then
          if not reeItems[idx] then
            reeItems[idx] = {}
          end
          --check for duplicate item in list
          for k=1,idx do
            itemIsDuplicate = false
            if reeItems[k].name == itemName then
              itemIsDuplicate = true
              --reePrint("found duplicate item "..itemName)
              break
            end
          end
          if not itemIsDuplicate then
            reeItems[idx].bag = i
            reeItems[idx].slot = j
            reeItems[idx].name = itemName
            reeItems[idx].texture = itemTexture
            --reePrint("Found item " ..reeItems[idx].name)
            idx = idx + 1
          end
        end
      end
    end
  end

  -- display trinkets outward from docking point
  local xpos,ypos = 8,44
  reeConsumableCounter = math.min(reeConsumableMax,idx-1)
  for i=1,reeConsumableCounter do
    local item = getglobal("reeMainFrameItem"..i)
    getglobal("reeMainFrameItem"..i.."Icon"):SetTexture(reeItems[i].texture)
    item:SetPoint("TOPLEFT","reeMainFrameItem","BOTTOMLEFT",xpos,ypos)
    ypos = ypos + 40
    item:Show()
  end
  for i=(reeConsumableCounter+1),reeConsumableMax do
    getglobal("reeMainFrameItem"..i):Hide()
  end

  reeMainFrameItem:SetWidth(12+40)
  reeMainFrameItem:SetHeight(12+40*reeConsumableCounter)
  --TrinketMenu.UpdateMenuCooldowns()
  reeMainFrameItem:Show()
  --TrinketMenu.StartTimer("MenuMouseover")
end

function reeUseItem(reeItemNumber)
  UseItemByName(reeItems[reeItemNumber].name)
  reeScanBags()
end
