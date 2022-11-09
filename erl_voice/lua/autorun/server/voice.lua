AddCSLuaFile("lua/autorun/client/cl_voice.lua")
util.AddNetworkString("erl_voiceRangeTransmiter")

local config = include("../voice_config.lua") 

erl_voice = {}

erl_voicesv = {}
erl_voicesv.options = {23000,359684,886371}



hook.Add("PlayerCanHearPlayersVoice", "Togglevoice", function(listner, ply)
    if listner:GetPos():DistToSqr(ply:GetPos()) <= erl_voicesv.options[erl_voice[ply].set] then
        return true, true
    else
        return false
    end
end)

hook.Add("OnPlayerChangedTeam", "erl_voiceChangeSettingOnJobChange", function(ply)
    erl_voice[ply].job = ply:getDarkRPVar("job")

    if erl_voice[ply].set > config[erl_voice[ply].job] then

        erl_voice[ply].set = config[erl_voice[ply].job]

        net.Start("erl_voiceRangeTransmiter")
            net.WriteInt(erl_voice[ply].set, 16)
        net.Send(ply)

    end
end)

hook.Add("Think", "SvJobThing", function()
    for k,ply in pairs(player.GetAll()) do 
        erl_voice[ply] = erl_voice[ply] or {}  
        erl_voice[ply].k = erl_voice[ply].k or 0
        erl_voice[ply].set = erl_voice[ply].set or 1

        erl_voice[ply].job = v:getDarkRPVar("job")
    end
end)

concommand.Add("voicesett", function(ply)

    erl_voice[ply].k = erl_voice[ply].k + 1

    erl_voice[ply].set = erl_voice[ply].k % config[erl_voice[ply].job] + 1

    net.Start("erl_voiceRangeTransmiter")
        net.WriteInt(erl_voice[ply].set, 16)
    net.Send(ply)

end)