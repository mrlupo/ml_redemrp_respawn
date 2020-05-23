local firstspawn = true
local new_character = 0
local respawned = false
local dsbl = true
--lupo
local reviveWait = 60 -- Change the amount of time to wait before allowing revive (in seconds)
local isDead = false
local warned = false
local timerCount = reviveWait




RegisterCommand("die", function(source, args, rawCommand) -- KILL YOURSELF COMMAND
local _source = source
if Config.kysCommand then
	local pl = Citizen.InvokeNative(0x217E9DC48139933D)
    local ped = Citizen.InvokeNative(0x275F255ED201B937, pl)
        Citizen.InvokeNative(0x697157CED63F18D4, ped, 500000, false, true, true)
		else end
end, false)

--lupo

RegisterNetEvent("redemrp_respawn:revivepl")
AddEventHandler("redemrp_respawn:revivepl", function()
	local ply = PlayerPedId()
	local coords = GetEntityCoords(ply)
	
	DoScreenFadeOut(1000)
	Wait(1000)
	DoScreenFadeIn(1000)
				   
	ResurrectPed(PlayerPedId(ply))

	SetCamActive(gameplaycam, true)
	DisplayHud(true)
	DisplayRadar(true)

	
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
end)

--lupo
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
			
            if IsControlJustReleased(0, 0xCEFD9220) then
                if timerCount <= 0 then
                   
					SimpleRespawn2()
					
                end	
            elseif IsControlJustReleased(0, 0xE30CD707)  then
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

Citizen.CreateThread(function()
    while true do
        if isDead then
			timerCount = timerCount - 1
        end
        Citizen.Wait(1000)          
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


RegisterNetEvent("redemrp_respawn:respawn")
AddEventHandler("redemrp_respawn:respawn", function(new1)
	local new = new1
	new_character = tonumber(new)
	if Config.UseSingleSpawn then
		DoScreenFadeOut(1000)
		Wait(3000)
		if firstspawn then 
			TriggerServerEvent("redemrp_respawn:FirstSpawn")
			DoScreenFadeIn(1000)
		else
			SimpleRespawn2()
		end
		CoordsSave()
	else
		respawn()
	end
end)

--mr lupo
function SimpleRespawn2(lightning)
	local ply = PlayerPedId()
	local coords = GetEntityCoords(ply)
	
	DoScreenFadeOut(1000)
	Wait(1000)
	DoScreenFadeIn(1000)
	isDead = false
	timerCount = reviveWait
	NetworkResurrectLocalPlayer(coords, true, true, false)
	ClearTimecycleModifier()
	ClearPedTasksImmediately(ply)
	SetEntityVisible(ply, true)
	NetworkSetFriendlyFireOption(true)


	SetCamActive(gameplaycam, true)
	DisplayHud(true)
	DisplayRadar(true)
	
	--TriggerEvent("redemrp_respawn:lupocamera", coords, lightning)
	
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
	--	TriggerServerEvent("redemrp_skin:loadSkin", function(cb)
		--end)
	end
end

function CoordsSave()
	Citizen.CreateThread(function()
		while true do 
			if Config.SaveCoords then
				Wait(Config.SaveDelay)
				local coordss = GetEntityCoords(PlayerPedId())
				TriggerServerEvent("redemrp_respawn:SaveCoordsFromClient", coordss)
			end
		end
	end)
end

RegisterNetEvent("redemrp_respawn:SaveFromAndToServer")
AddEventHandler("redemrp_respawn:SaveFromAndToServer", function()
	local coordss = GetEntityCoords(PlayerPedId())
	TriggerServerEvent("redemrp_respawn:SaveCoordsFromClient", coordss)
end)

RegisterNetEvent("redemrp_respawn:FirstSpawnClient")
AddEventHandler("redemrp_respawn:FirstSpawnClient",function(coords)

	local ply = PlayerId()
	DoScreenFadeIn(500)
	ShutdownLoadingScreen()
	SetEntityVisible(ply, true)
	NetworkSetFriendlyFireOption(true)
	
	Cam1 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Config.SingleSpawnCam.x,Config.SingleSpawnCam.y,Config.SingleSpawnCam.z, 300.00,0.00,0.00, 100.00, false, 0) -- CAMERA COORDS
	SetCamActive(Cam1, true)
	RenderScriptCams(true, true, 1000, true, true)
	Wait(1000)

	if coords ~= nil then 
		local _coords = {coords.x,coords.y,coords.z}
		Cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords.x,coords.y,coords.z+6, 300.00,0.00,0.00, 100.00, false, 0)
		PointCamAtCoord(Cam2, coords.x,coords.y,coords.z+3)
	else 
		Cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Config.SingleFirstSpawn.x,Config.SingleFirstSpawn.y,Config.SingleFirstSpawn.z+6, 300.00,0.00,0.00, 100.00, false, 0)
		PointCamAtCoord(Cam2, Config.SingleFirstSpawn.x,Config.SingleFirstSpawn.y,Config.SingleFirstSpawn.z+3)
	end

	SetCamActiveWithInterp(Cam2, Cam1, 5000, false, false)
	Wait(5000)
	
	RenderScriptCams(false, true, 7000, true, true)
	DestroyCam(Cam1, true)
	DestroyCam(Cam2, true)
	DisplayHud(true)
	DisplayRadar(true)
	
	firstspawn = false
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
	if coords == nil then 
		NetworkResurrectLocalPlayer(Config.SingleFirstSpawn.x,Config.SingleFirstSpawn.y,Config.SingleFirstSpawn.z)
	else
		NetworkResurrectLocalPlayer(coords.x,coords.y,coords.z, Config.SingleSpawnHeading, true, true, false)
	end

	TriggerEvent('playerSpawned',_coords)

end)

RegisterNetEvent('redemrp_respawn:newcamera')
AddEventHandler('redemrp_respawn:newcamera', function(cord,light)
	local coords = cord
	
	
	if Config.UseSingleSpawn then
		DoScreenFadeIn(6000)
		Cam1 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords.x,coords.y,coords.z, 0.00,0.00,0.00, 0.00, false, 0)
		--Cam1 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Config.SingleSpawnCam.x,Config.SingleSpawnCam.y,Config.SingleSpawnCam.z, 300.00,0.00,0.00, 100.00, false, 0) -- CAMERA COORDS
    	SetCamActive(Cam1, true)
    	RenderScriptCams(true, true, 5000, true, true)
		Wait(1000)
		
		Cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords.x,coords.y,coords.z, 0.00,0.00,0.00, 0.00, false, 0)
		PointCamAtCoord(Cam2, coords.x,coords.y,coords.z+3)
		SetCamActiveWithInterp(Cam2, Cam1, 10000, false, false)
		Wait(2000)
		if Config.SingleSpawnUseLightning and light then
			Citizen.InvokeNative(0x67943537D179597C, Config.LightningCoords.x,Config.LightningCoords.y,Config.LightningCoords.z)
		end
		Wait(8000)
		
		RenderScriptCams(false, true, 2500, true, true)
    	DestroyCam(Cam1, true)
		DestroyCam(Cam2, true)
		DisplayHud(true)
		DisplayRadar(true)
		Wait(5000)
	
	end
	TriggerEvent("initializeVoip")
end)

RegisterNetEvent('redemrp_respawn:lupocamera')
AddEventHandler('redemrp_respawn:lupocamera', function()
	
	if Config.UseSingleSpawn then
	
	DoScreenFadeOut(1000)
	Wait(1000)
	DoScreenFadeIn(1000)
	gameplaycam = GetRenderingCam()
	cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -1850.33, -901.9, 147.78, 300.00,0.00,0.00, 100.00, false, 0)
	DoesCamExist(cam)
	SetCamCoord(cam, -1850.33, -901.9, 147.78)
	PointCamAtCoord(cam, -1875.75, -912.91, 137.91)
	RenderScriptCams(true, false, 1, true, true)
	SetCamActive(cam, true)
	--startdialog()
	Wait(10000)
	SetCamCoord(cam,GetGameplayCamCoord())
	SetCamRot(cam, GetGameplayCamRot(2), 2)
	RenderScriptCams( 1, 1, 0, 0, 0)
	RenderScriptCams( 0, 1, 1000, 0, 0)
	SetCamActive(gameplaycam, true)
	SetCamActive(cam, false)
	DestroyCam(cam, true)
	DisplayHud(true)
	DisplayRadar(true)
	
	end
	TriggerEvent("initializeVoip")
end)
--=============================================================-- DRAW TEXT SECTION --=============================================================--
--lupo
function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
    local str = CreateVarString(10, "LITERAL_STRING", str)
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
-----------------------------------------------------------------------------------------NUI-------------------------------------------------------------
RegisterNUICallback('select', function(spawn, cb)
	print(spawn)
	print('What tha hek is this ?')
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
	TriggerEvent("redemrp_respawn:newcamera", coords)
	if Config.UsingInventory then
		TriggerServerEvent("player:getItems", source)
	else end
	if new_character == 1 then
		TriggerEvent("redemrp_skin:openCreator")
		print("new character")
		new_character = 0
	else
	TriggerServerEvent("redemrp_skin:loadSkin", function(cb)
		end)
		if Config.UsingClothes then
			LoadClothes()
		else end
	end
end)

function LoadClothes()
	Citizen.CreateThread(function()
		Citizen.Wait(3000)
		--TriggerServerEvent("redemrp_clothing:loadClothes", 1, function(cb)
		--end)
	end)
end