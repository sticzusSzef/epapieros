local thingsToSay = {
	"delektuje się smakiem arbuza zerówki",
	"dusi się zerówką",
	"jara sperme trójkę"
}

local szlugtimeleft = 1
local vaping = false

ESX = nil
PlayerData = {}

ESX = exports['es_extended']:getSharedObject()


RegisterNetEvent("upiczek_eszlugi:usedItem", function()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local ad = "mp_player_inteat@burger"
	local anim = "mp_player_int_eat_burger"
	if (DoesEntityExist(ped) and not IsEntityDead(ped)) and not vaping then
		vaping = false
		while (not HasAnimDictLoaded(ad)) do
			RequestAnimDict(ad)
			Wait(1)
		end
		vape = CreateObject(GetHashKey("ba_prop_battle_vape_01"), coords.x, coords.y, coords.z+0.2,  false,  false, false)
		AttachEntityToEntity(vape, ped, GetPedBoneIndex(ped, 18905), 0.08, -0.00, 0.03, -150.0, 90.0, -10.0, false, false, false, false, 1, false)
		TaskPlayAnim(ped, ad, anim, 8.00, -8.00, -1, (2 + 16 + 32), 0.00, 0, 0, 0)
		PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
		local random = math.random(1, 3)
		local tekst = thingsToSay[random]
		ExecuteCommand("me " .. tekst)
		Wait(950)
		TriggerServerEvent("upiczek_eszlugi:efekcik", PedToNet(ped), coords)
		szlugtimeleft = 60
		SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
		Wait(950)
		DeleteObject(vape)
        StopAnimTask(ped, ad, anim, 1.0)
		vaping = false
	end
end)
RegisterNetEvent("upiczek_eszlugi:rubHmure", function(ped, coords)
	local distance = #(GetEntityCoords(PlayerPedId()) - coords)
	if distance <= 100 then
		if DoesEntityExist(NetToPed(ped)) and not IsEntityDead(NetToPed(ped)) then
			Smoke = UseParticleFxAssetNextCall("core")
			Particle = StartParticleFxLoopedOnEntityBone("exp_grd_bzgas_smoke", NetToPed(ped), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPedBoneIndex(NetToPed(ped), 20279), 0.5, 0.0, 0.0, 0.0)
			Wait(2800)
			while DoesParticleFxLoopedExist(Smoke) do
				StopParticleFxLooped(Smoke, 1)
				Wait(0)
			end
			while DoesParticleFxLoopedExist(Particle) do
				StopParticleFxLooped(Particle, 1)
				Wait(0)
			end
			while DoesParticleFxLoopedExist("exp_grd_bzgas_smoke") do
				StopParticleFxLooped("exp_grd_bzgas_smoke", 1)
				Wait(0)
			end
			while DoesParticleFxLoopedExist("core" ) do
				StopParticleFxLooped("core" , 1)
				Wait(0)
			end
			Wait(3800 * 3)
			RemoveParticleFxFromEntity(NetToPed(ped))
		end
	end
end)


CreateThread(function()
    while false do
        Wait(1000)
        if szlugtimeleft > 0 then
            local playerid = PlayerId()
            ResetPlayerStamina(playerid)
            szlugtimeleft = szlugtimeleft - 1
            if szlugtimeleft == 1 or exports["esx_ambulancejob"]:isDead() then
                SetRunSprintMultiplierForPlayer(playerid, 1.0)
                ESX.ShowNotification('~r~Efekt szybkości E-Szluga zanika...')
                szlugtimeleft = 0
            end
        end
    end
end)
