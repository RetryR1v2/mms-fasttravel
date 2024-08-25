local VORPcore = exports.vorp_core:GetCore()

-----------------------------------------------------------------------
-- version checker
-----------------------------------------------------------------------
local function versionCheckPrint(_type, log)
    local color = _type == 'success' and '^2' or '^1'

    print(('^5['..GetCurrentResourceName()..']%s %s^7'):format(color, log))
end

local function CheckVersion()
    PerformHttpRequest('https://raw.githubusercontent.com/RetryR1v2/mms-fasttravel/main/version.txt', function(err, text, headers)
        local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')

        if not text then 
            versionCheckPrint('error', 'Currently unable to run a version check.')
            return 
        end

      
        if text == currentVersion then
            versionCheckPrint('success', 'You are running the latest version.')
        else
            versionCheckPrint('error', ('Current Version: %s'):format(currentVersion))
            versionCheckPrint('success', ('Latest Version: %s'):format(text))
            versionCheckPrint('error', ('You are currently running an outdated version, please update to version %s'):format(text))
        end
    end)
end

RegisterServerEvent('mms-fasttravel:server:TravelToo',function(Tp,SpawnCoords,SpawnHeading,LocationName)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local Firstname = Character.firstname
    local Lastname = Character.lastname
    local Money = Character.money
    if Money >= Tp then
        Character.removeCurrency(0, Tp)
        if Config.WebHook then
            VORPcore.AddWebhook(Config.WHTitle, Config.WHLink, Firstname .. ' ' .. Lastname .. _U('TraveledTo') .. LocationName .. _U('For') .. Tp, Config.WHColor, Config.WHName, Config.WHLogo, Config.WHFooterLogo, Config.WHAvatar)
        end
        TriggerClientEvent('mms-fasttravel:client:TravelToo2',src,Tp,SpawnCoords,SpawnHeading,LocationName)
    else
        VORPcore.NotifyTip(src,_U('NotEnoghMoney'),5000)
    end
end)


--------------------------------------------------------------------------------------------------
-- start version check
--------------------------------------------------------------------------------------------------
CheckVersion()