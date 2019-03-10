choice_loot = {function(player,choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
      local nplayer = vRPclient.getNearestPlayer(player,10)
      local nuser_id = vRP.getUserId(nplayer)
      if nuser_id ~= nil then
        local in_coma = vRPclient.isInComa(nplayer)
          if in_coma then
			local revive_seq = {
			  {"amb@medic@standing@kneel@enter","enter",1},
			  {"amb@medic@standing@kneel@idle_a","idle_a",1},
			  {"amb@medic@standing@kneel@exit","exit",1}
			}
  			vRPclient._playAnim(player,false,revive_seq,false) -- anim
            SetTimeout(15000, function()
              local ndata = vRP.getUserDataTable(nuser_id)
              if ndata ~= nil then
			    if ndata.inventory ~= nil then
				  vRP.clearInventory(nuser_id)
                  for k,v in pairs(ndata.inventory) do 
			        vRP.giveInventoryItem(user_id,k,v.amount,true)
	              end
				end
			  end
			  local weapons = vRPclient.replaceWeapons(nplayer, {})
        for k,v in pairs(weapons) do
          vRP.giveInventoryItem(user_id, "wbody|"..k, 1, true)
          if v.ammo > 0 then
            vRP.giveInventoryItem(user_id, "wammo|"..k, v.ammo, true)
          end
        end
			  local nmoney = vRP.getMoney(nuser_id)
			  if vRP.tryPayment(nuser_id,nmoney) then
			    vRP.giveMoney(user_id,nmoney)
			  end
            end)
			vRPclient._stopAnim(player,false)
          else
            vRPclient._notify(player,lang.emergency.menu.revive.not_in_coma())
          end
      else
        vRPclient._notify(player,lang.common.no_player_near())
      end
    end
end,lang.loot.desc()}
