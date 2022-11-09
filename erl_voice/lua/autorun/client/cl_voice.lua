local mainCol = Color(cookie.GetNumber("MainColorR",69), cookie.GetNumber("MainColorG",68),cookie.GetNumber("MainColorB",68), cookie.GetNumber("MainColorA",255))
local textCol = Color(cookie.GetNumber("TextColR",255), cookie.GetNumber("TextColG",255), cookie.GetNumber("TextColB",255), cookie.GetNumber("TextColA",255))

hook.Add( "InitPostEntity", "erl_voice_postinit", function()

    erl_clvoice = {}
    erl_clvoice.set = 1 

    hook.Add("HUDPaint", "volume range", function()
        draw.RoundedBox(3, 240, 90, 20, 20, mainCol)
    end)

    local voice_button = vgui.Create("DButton")
    voice_button:SetPos(240, 90)
    voice_button:SetSize(20, 20)
    voice_button:SetTextColor(textCol)


    hook.Add("Think","erl_voicethink", function()
        if erl_clvoice.set == 1 then
            voice_button:SetText("W")
        elseif erl_clvoice.set == 2 then
            voice_button:SetText("N")
        elseif erl_clvoice.set == 3 then
            voice_button:SetText("S")
        else
            voice_button:SetText("?")
        end
    end)

    function voice_button:Paint(w,h) 
        draw.RoundedBox( 3, 0, 0, w, h, mainCol )
    end 


end)
net.Receive("erl_voiceRangeTransmiter", function()
    erl_clvoice.set = net.ReadInt(16)
end)