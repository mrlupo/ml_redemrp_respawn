local playerCoords = {}

RegisterServerEvent("redemrp_respawn:CheckPos")
AddEventHandler("redemrp_respawn:CheckPos", function()
local _source = source
    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
        MySQL.Async.fetchAll('SELECT * FROM characters WHERE `identifier`=@identifier AND `characterid`=@charid;', {identifier = user.get('identifier'), charid = user.getSessionVar("charid")}, function(result)            
            if(result[1].coords ~= "{}")then
                TriggerClientEvent("redemrp_respawn:respawnCoords", _source, json.decode(result[1].coords))
            end
        end)        
    end)
end)

RegisterServerEvent("redemrp_respawn:registerCoords")
AddEventHandler("redemrp_respawn:registerCoords", function(coords)
    playerCoords[source] = coords
end)

AddEventHandler("redemrp:playerDropped", function(player)
    local coords = playerCoords[player.get('source')]
    local characterId = player.getSessionVar("charid")
    local identifier = player.get('identifier')

    if coords then
        MySQL.Async.execute('UPDATE characters SET `coords`=@coords WHERE `identifier`=@identifier AND `characterid`=@charid;', {coords = json.encode(coords), identifier = identifier, charid = characterId})
    end
end)


--lupo

RegisterCommand("revive", function(source, args, rawCommand)
		if args[1] == nil then
			print("argument #1 is bad")
		else
			TriggerEvent("redemrp:reviveplayer", source, args[1], function(cb)end)
		end
end, false)

RegisterServerEvent('redemrp:reviveplayer')
AddEventHandler("redemrp:reviveplayer", function(source, id, cb)
	local _perm = tonumber(source)
	TriggerEvent('redemrp:getPlayerFromId', _perm, function(pg)
	if _perm ~= 0 and (pg.getGroup() ~= "admin" and pg.getGroup() ~= "superadmin") then
		print(pg.getName() .. " - With ID: " .. _perm .. " - TRIED TO RUN ADMIN COMMAND WITHOUT PERMISSION")	
	else	
		local _source = tonumber(id)
		TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
		
			if user == nil then
				--TODO Temporary command Feeback	
				print("Admin command Feedback: this user doesnt exist")
			else
			
				
				TriggerClientEvent('redemrp_respawn:revivepl', id)
				print("revived user: "..user.getName())
				end
			end)
		end
	end)
end)