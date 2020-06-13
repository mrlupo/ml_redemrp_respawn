# ml_redemrp_respawn
My own edit of redemrp_respawn
added admin revive players /revive [id]
added menu at the end of timer R to respawn via the map

- open redemrp_skin and replace  lines 60 to 81 on client side :

RegisterCommand("creator", function(source, args, rawCommand)
    TriggerEvent('redemrp_skin:openCreator')
end)

RegisterNetEvent('redemrp_skin:openCreator')
AddEventHandler('redemrp_skin:openCreator', function(source)
	Wait(5000)
    SetNuiFocus(true, true)
    local ped = PlayerPedId()
	SetEntityCoords(ped, -798.67, -1208.77, 43.55)
	SetEntityHeading(ped, 181.6)
	cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -798.33,-1211.74,44.58, 300.00,0.00,0.00, 40.00, false, 0)
	PointCamAtCoord(cam, -798.67, -1208.77, 44.55)
	SetCamActive(cam, true)
	RenderScriptCams(true, false, 1, true, true)
	DisplayHud(false)
	DisplayRadar(false)
	FreezeEntityPosition(ped, true)
	SendNUIMessage({
        show = 1
    })
end)

---------------- with this ------------------- :

RegisterCommand("creator", function(source, args, rawCommand)
    TriggerEvent('redemrp_skin:openCreator')
end)

RegisterNetEvent('redemrp_skin:openCreator')
AddEventHandler('redemrp_skin:openCreator', function(source)
	local ped = PlayerPedId()
	local randomNCoords = math.random(3)
	
	--Wait(3000) do we need this?
	
	if randomNCoords == 1 then
		SetEntityCoords(ped, -171.57, 635.16, 113.03)
		print("spawn 1")
		creator()
	elseif randomNCoords == 2 then
		SetEntityCoords(ped, -170.72, 636.30, 113.03)
		print("spawn 2")
		creator()
	elseif randomNCoords == 3 then
		SetEntityCoords(ped, -170.40, 637.06, 113.03)
		print("spawn 3")
		creator()
	end
end)

function creator()
	print("opening creator")
	local ped = PlayerPedId()
	SetNuiFocus(true, true)
	--SetEntityCoords(ped, -798.67, -1208.77, 43.55)
	SetEntityHeading(ped, 65.6)
	cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -175.10,638.65,114.55, 300.00,0.00,0.00, 40.00, false, 0)
	PointCamAtCoord(cam, -170.72, 636.30, 114.03)
	SetCamActive(cam, true)
	RenderScriptCams(true, false, 1, true, true)
	DisplayHud(false)
	DisplayRadar(false)
	FreezeEntityPosition(ped, true)
	SendNUIMessage({
        show = 1
    })
end
