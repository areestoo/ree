SLASH_REE1 = "/ree"
SLASH_REE2 = "/raidseateverything"
BINDING_HEADER_KITTYONE = "RaidsEatEverything v0.1"
reeVersion = "|cffffffffv0.1 by |cff4c8affAreesto"

RaidsEatEverything = CreateFrame("Frame", nil)
RaidsEatEverything:RegisterEvent("PLAYER_ENTERING_WORLD")

SlashCmdList["REE"] = function(message)
	local cmd = { }
	for c in string.gfind(message, "[^ ]+") do
		table.insert(cmd, string.lower(c))
	end

  if not cmd[1] then
    reePrint("syntax here")
  elseif cmd[1] == "options" then
    reePrint("options")
  else
    reePrint("Unrecognized or incorrect syntax. Use /ree help for list of available commands.")
  end
end

function reeOnLoad()
  reePrint(reeVersion.."|cffffffff loaded! |cff42e5f4/ree |cfffffffffor options - |cff4c8aff https://gitlab.com/areesto");
end



function reePrint(input_str)
  DEFAULT_CHAT_FRAME:AddMessage("|cff42e5f4RaidsEatEverything: |cffffffff"..input_str)
end
