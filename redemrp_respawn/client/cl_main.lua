local new_character = 0
local respawned = false
local alive = false
local firstjoin = true
local firstSpawn = false
local pressed = false


--lupo
local reviveWait = 60 -- Change the amount of time to wait before allowing revive (in seconds)
local isDead = false
local warned = false
local timerCount = reviveWait


RegisterCommand("die1", function(source, args, rawCommand) -- KILL YOURSELF COMMAND
	local _source = source
	if Config.kysCommand then
		local pl = Citizen.InvokeNative(0x217E9DC48139933D)
    	local ped = Citizen.InvokeNative(0x275F255ED201B937, pl)
        Citizen.InvokeNative(0x697157CED63F18D4, ped, 500000, false, true, true)
	end
end, false)

-- ml lupo 
Citizen.CreateThread(function()
	local respawnCount = 0
	local spawnPoints = {}

    while true do
    Citizen.Wait(0)
	local pl = Citizen.InvokeNative(0x217E9DC48139933D)
        while Citizen.InvokeNative(0x2E9C3FCB6798F397, pl) do
		Citizen.Wait(0) -- DO NOT REMOVE
			local timer = GetGameTimer()
			Citizen.InvokeNative(0x405224591DF02025, 0.50, 0.475, 1.0, 0.22, 1, 1, 1, 100, true, true)
			DrawTxt(Config.LocaleDead, 0.50, 0.45, 1.0, 1.0, true, 161, 3, 0, 255, true)
			DrawTxt("You will respawn in "..timerCount.." seconds", 0.50, 0.52, 0.7, 0.7, true, 255, 255, 255, 255, true)
			isDead = true
           
			exports.spawnmanager:setAutoSpawn(false) -- disable respawn
			
			if timerCount <= 0 then
			Citizen.InvokeNative(0x405224591DF02025, 0.50, 0.475, 1.0, 0.22, 1, 1, 1, 100, true, true)
			DrawTxt(Config.LocaleRevive, 0.50, 0.38, 1.0, 1.0, true, 161, 3, 0, 255, true)
			end
				
            if IsControlJustReleased(0, 0xE30CD707)  then
                 if timerCount <= 0 then
				
					respawn()
				
                end	
				isDead = false
				timerCount = reviveWait
				respawnCount = respawnCount + 1
				
            end
        end
    end
end)

function respawn()
	SendNUIMessage({
		type = 1,
		showMap = true
	})
	SetNuiFocus(true, true)
	
	local pl = Citizen.InvokeNative(0x217E9DC48139933D)
	local ped = Citizen.InvokeNative(0x275F255ED201B937, pl)
	local coords = GetEntityCoords(ped, false)
	SetEntityCoords(ped, coords.x, coords.y, coords.z - 128.0)
	FreezeEntityPosition(ped, true)
    Citizen.InvokeNative(0x71BC8E838B9C6035, ped)
	Citizen.InvokeNative(0x0E3F4AF2D63491FB)
	DisplayHud(true)
	DisplayRadar(true)
	
	Citizen.InvokeNative(0x50C803A4CD5932C5, true)
    Citizen.InvokeNative(0xC6258F41D86676E0, GetPlayerPed(), 0, 100)
    Citizen.InvokeNative(0xC6258F41D86676E0, GetPlayerPed(), 1, 100)
	
	TriggerEvent("ml_needs:resetall")
	--TriggerEvent("initializeVoip")
	
	if Config.UsingInventory then
		TriggerServerEvent("player:getItems", source)
	end
	
	if Config.UsingClothes then
		LoadClothes()
	end
	
	if new_character == 1 then
		TriggerEvent("redemrp_skin:openCreator")
		new_character = 0
	else
		TriggerServerEvent("redemrp_skin:loadSkin", function(cb)
		end)
	end
	
end

RegisterNetEvent("redemrp_respawn:revivepl")
AddEventHandler("redemrp_respawn:revivepl", function()
	local ply = PlayerPedId()
	local coords = GetEntityCoords(ply)
	
	DoScreenFadeOut(1000)
	Wait(1000)
	DoScreenFadeIn(1000)
				   
	ResurrectPed(PlayerPedId(ply))
	TriggerEvent("ml_needs:resetall")
	SetCamActive(gameplaycam, true)
	DisplayHud(true)
	DisplayRadar(true)
	
	Citizen.InvokeNative(0x50C803A4CD5932C5, true)
    Citizen.InvokeNative(0xC6258F41D86676E0, GetPlayerPed(), 0, 100)
    Citizen.InvokeNative(0xC6258F41D86676E0, GetPlayerPed(), 1, 100)
	
	timerCount = reviveWait
	
	if Config.UsingInventory then
		TriggerServerEvent("player:getItems", source)
	end
	
	if Config.UsingClothes then
		LoadClothes()
	end
	if new_character == 1 then
		TriggerEvent("redemrp_skin:openCreator")
		new_character = 0
	else
	
	end
	
	--TriggerEvent("initializeVoip")
end)


Citizen.CreateThread(function()
    while true do
        if isDead then
			timerCount = timerCount - 1
        end
        Citizen.Wait(1000)          
    end
end)

--lupo

RegisterNetEvent("redemrp_respawn:respawn")
AddEventHandler("redemrp_respawn:respawn", function(new1)
	local new = new1
	new_character = tonumber(new)
	respawn()
end)

RegisterNetEvent("redemrp_respawn:respawnCoords")
AddEventHandler("redemrp_respawn:respawnCoords", function(coords)
	local ped = PlayerPedId()
	SetEntityCoords(ped, coords.x, coords.y, coords.z)
	SetNuiFocus(false, false)
	SendNUIMessage({
		type = 1,
		showMap = false
	})
	FreezeEntityPosition(ped, false)

	ShutdownLoadingScreen()
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, 59.95, true, true, false)
	local ped = PlayerPedId()
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	ClearPedTasksImmediately(ped)
	ClearPlayerWantedLevel(PlayerId())
	FreezeEntityPosition(ped, false)
	SetPlayerInvincible(PlayerId(), false)
	SetEntityVisible(ped, true)
	SetEntityCollision(ped, true)
	TriggerEvent('playerSpawned')
	Citizen.InvokeNative(0xF808475FA571D823, true)
	NetworkSetFriendlyFireOption(true)

	TriggerEvent("redemrp_respawn:camera", coords)

	alive = true
	TriggerServerEvent("redemrp_respawn:registerCoords", coords)
end)

RegisterNUICallback('select', function(spawn, cb)
	local coords = Config[spawn][math.random(#Config[spawn])]
	local ped = PlayerPedId()
	SetEntityCoords(ped, coords.x, coords.y, coords.z)
	SetNuiFocus(false, false)
	SendNUIMessage({
		type = 1,
		showMap = false
	})
	FreezeEntityPosition(ped, false)

	ShutdownLoadingScreen()
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, 59.95, true, true, false)
	local ped = PlayerPedId()
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	ClearPedTasksImmediately(ped)
	ClearPlayerWantedLevel(PlayerId())
	FreezeEntityPosition(ped, false)
	SetPlayerInvincible(PlayerId(), false)
	SetEntityVisible(ped, true)
	SetEntityCollision(ped, true)
	TriggerEvent('playerSpawned', spawn)
	Citizen.InvokeNative(0xF808475FA571D823, true)
	NetworkSetFriendlyFireOption(true)

	TriggerEvent("redemrp_respawn:camera", coords)
	
	if new_character == 1 then
		TriggerEvent("redemrp_skin:openCreator")
		print("new character")
		new_character = 0
	end
	
	alive = true
	TriggerServerEvent("redemrp_respawn:registerCoords", coords)
end)

Citizen.CreateThread(function()
	while true do
		Wait(20000)

		if alive then
			local coords = GetEntityCoords(PlayerPedId())
			TriggerServerEvent("redemrp_respawn:registerCoords", {x = coords.x, y = coords.y, z = coords.z})
		end
	end
end)

RegisterNetEvent('redemrp_respawn:camera')
AddEventHandler('redemrp_respawn:camera', function(cord)
	DoScreenFadeIn(500)
	local coords = cord
	cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 621.67,374.08,873.24, 300.00,0.00,0.00, 100.00, false, 0) -- CAMERA COORDS
	PointCamAtCoord(cam, coords.x,coords.y,coords.z+200)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
	DoScreenFadeIn(500)
	Citizen.Wait(500)
	
	cam3 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords.x,coords.y,coords.z+200, 300.00,0.00,0.00, 100.00, false, 0)
    PointCamAtCoord(cam3, coords.x,coords.y,coords.z+200)
    SetCamActiveWithInterp(cam3, cam, 3700, true, true)
    Citizen.Wait(3700)
	
	cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords.x,coords.y,coords.z+200, 300.00,0.00,0.00, 100.00, false, 0)
	PointCamAtCoord(cam2, coords.x,coords.y,coords.z+2)
	SetCamActiveWithInterp(cam2, cam3, 3700, true, true)
	RenderScriptCams(false, true, 500, true, true)
	Citizen.Wait(500)
    SetCamActive(cam, false)
    DestroyCam(cam, true)
	DestroyCam(cam2, true)
	DestroyCam(cam3, true)
	DisplayHud(true)
    DisplayRadar(true)
	Citizen.Wait(3000)
	
end)
--=============================================================-- DRAW TEXT SECTION--=============================================================--
function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
    local str = CreateVarString(10, "LITERAL_STRING", str)


    --Citizen.InvokeNative(0x66E0276CC5F6B9DA, 2)
    SetTextScale(w, h)
    SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
	SetTextCentre(centre)
    if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
	Citizen.InvokeNative(0xADA9255D, 1);
    DisplayText(str, x, y)
end

function CreateVarString(p0, p1, variadic)
    return Citizen.InvokeNative(0xFA925AC00EB830B9, p0, p1, variadic, Citizen.ResultAsLong())
end
