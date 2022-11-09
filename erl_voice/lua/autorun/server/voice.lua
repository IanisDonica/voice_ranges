AddCSLuaFile("lua/autorun/client/cl_voice.lua")
util.AddNetworkString("erl_voiceRangeTransmiter")

local config = include("../voice_config.lua") 

erl_voice = {}

erl_voicesv = {}
erl_voicesv.options = {23000,359684,886371}



hook.Add("PlayerCanHearPlayersVoice", "Togglevoice", function(listner, ply)
    print("talking")
    erl_voice.x = erl_voice.x or 0
    erl_voice.x = erl_voice.x + 1 
    print(erl_voice.x)
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
    for k,v in pairs(ents.GetAll()) do 
        if v:IsPlayer() then 
            erl_voice[v] = erl_voice[v] or {}  
            erl_voice[v].k = erl_voice[v].k or 0
            erl_voice[v].set = erl_voice[v].set or 1

            erl_voice[v].job = v:getDarkRPVar("job")
            erl_voice[v].maxv = config[erl_voice[v].job]
        end
    end
end)

concommand.Add("voicesett", function(ply)

    erl_voice[ply].k = erl_voice[ply].k + 1

    erl_voice[ply].set = erl_voice[ply].k % erl_voice[ply].maxv + 1

    net.Start("erl_voiceRangeTransmiter")
        net.WriteInt(erl_voice[ply].set, 16)
    net.Send(ply)

end)