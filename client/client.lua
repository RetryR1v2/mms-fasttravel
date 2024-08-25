local VORPcore = exports.vorp_core:GetCore()
local BccUtils = exports['bcc-utils'].initiate()
local FeatherMenu =  exports['feather-menu'].initiate()

-------------------------------------------------------------------------------------------------------
local CreatedTravelBlips = {}
local CreatedTravelNpcs = {}
local MenuOpened = false

Citizen.CreateThread(function()
        local FastTravelGroup = BccUtils.Prompts:SetupPromptGroup()
        local OpenTravelMenu = FastTravelGroup:RegisterPrompt(_U('PromptName'), 0x760A9C6F, 1, 1, true, 'hold', {timedeventhash = 'MEDIUM_TIMED_EVENT'})

        for h,v in ipairs(Config.FastTravel)do
            if v.ShowBlip then
                local TravelBlip = BccUtils.Blips:SetBlip(_U('BoardblipName'), v.BlipSprite, 0.2, v.NPCCoords.x,v.NPCCoords.y,v.NPCCoords.z)
                CreatedTravelBlips[#CreatedTravelBlips + 1] = TravelBlip
            end
            if v.SpawnNPC then
                local TravelPed = BccUtils.Ped:Create(v.NPCModel, v.NPCCoords.x, v.NPCCoords.y, v.NPCCoords.z -1, 0, 'world', false)
                CreatedTravelNpcs[#CreatedTravelNpcs + 1] = TravelPed
                TravelPed:Freeze()
                TravelPed:SetHeading(v.NPCHeading)
                TravelPed:Invincible()
                SetBlockingOfNonTemporaryEvents(TravelPed:GetPed(), true)
            end
        end

        while true do
            Wait(1)
            for h,v in pairs(Config.FastTravel) do
            local playerCoords = GetEntityCoords(PlayerPedId())
            local dist = #(playerCoords - v.PromptCoords)
            if dist < 2.5 then
                FastTravelGroup:ShowGroup(_U('GroupName'))
    
                if OpenTravelMenu:HasCompleted() then
                    TriggerEvent('mms-fasttravel:client:OpenMenu')
                end
            end
        end
        end
    end)

-- Menü

-- Open

RegisterNetEvent('mms-fasttravel:client:OpenMenu')
AddEventHandler('mms-fasttravel:client:OpenMenu',function ()
    if not MenuOpened then
        FastTravel = FeatherMenu:RegisterMenu('FastTravel', {
            top = '10%',
            left = '10%',
            ['720width'] = '500px',
            ['1080width'] = '700px',
            ['2kwidth'] = '700px',
            ['4kwidth'] = '800px',
            style = {
                ['border'] = '5px solid orange',
                -- ['background-image'] = 'none',
                ['background-color'] = '#FF8C00'
            },
            contentslot = {
                style = {
                    ['height'] = '600px',
                    ['min-height'] = '300px'
                }
            },
            draggable = true,
        --canclose = false
    }, {
        opened = function()
            --print("MENU OPENED!")
        end,
        closed = function()
            --print("MENU CLOSED!")
        end,
        topage = function(data)
            --print("PAGE CHANGED ", data.pageid)
        end
    })
        FastTravelPage1 = FastTravel:RegisterPage('seite1')
        FastTravelPage1:RegisterElement('header', {
            value = _U('FastTravelMenu'),
            slot = 'header',
            style = {
            ['color'] = 'orange',
            }
        })
        FastTravelPage1:RegisterElement('line', {
            slot = 'header',
            style = {
            ['color'] = 'orange',
            }
        })
        for i,button in ipairs(Config.FastTravel) do
            local MyCoords = GetEntityCoords(PlayerPedId())
            local dist = #(MyCoords - button.SpawnPoint)
            if Config.TravelPriceDistance then
                local Calculate = dist * Config.PricePerMeter
                local TravelPrice = math.floor(Calculate)
                local Label = _U('TravelToo') .. button.LocationName .. _U('For') .. TravelPrice
                FastTravelPage1:RegisterElement('button', {
                label = Label,
                style = {
                    ['background-color'] = '#FF8C00',
                    ['color'] = 'orange',
                    ['border-radius'] = '6px'
                },
                }, function()
                local Tp = TravelPrice
                local SpawnCoords = button.SpawnPoint
                local SpawnHeading = button.SpawnHeading
                local LocationName = button.LocationName
                TriggerEvent('mms-fasttravel:client:TravelToo',Tp,SpawnCoords,SpawnHeading,LocationName)
                FastTravel:Close({ 
                })
            end)
            else
                local TravelPrice = button.TravelPrice
                local Label = _U('TravelToo') .. button.LocationName .. _U('For') .. TravelPrice
                 FastTravelPage1:RegisterElement('button', {
                label = Label,
                style = {
                    ['background-color'] = '#FF8C00',
                    ['color'] = 'orange',
                    ['border-radius'] = '6px'
                },
                }, function()
                local Tp = TravelPrice
                local SpawnCoords = button.SpawnPoint
                local SpawnHeading = button.SpawnHeading
                local LocationName = button.LocationName
                TriggerEvent('mms-fasttravel:client:TravelToo',Tp,SpawnCoords,SpawnHeading,LocationName)
                FastTravel:Close({ 
                })
        end)
        end
        end
        FastTravelPage1:RegisterElement('button', {
            label =  _U('CloseFastTravel'),
            style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
            },
        }, function()
            FastTravel:Close({ 
            })
        end)
        FastTravelPage1:RegisterElement('subheader', {
            value = _U('FastTravelMenuBottom'),
            slot = 'footer',
            style = {
            ['color'] = 'orange',
            }
        })
        FastTravelPage1:RegisterElement('line', {
            slot = 'footer',
            style = {
            ['color'] = 'orange',
            }
        })
        FastTravel:Open({
            startupPage = FastTravelPage1,
        })
        MenuOpened = true
    elseif MenuOpened then
        FastTravelPage1:UnRegister()
        FastTravelPage1 = FastTravel:RegisterPage('seite1')
        FastTravelPage1:RegisterElement('header', {
            value = _U('FastTravelMenu'),
            slot = 'header',
            style = {
            ['color'] = 'orange',
            }
        })
        FastTravelPage1:RegisterElement('line', {
            slot = 'header',
            style = {
            ['color'] = 'orange',
            }
        })
        for i,button in ipairs(Config.FastTravel) do
            local MyCoords = GetEntityCoords(PlayerPedId())
            local dist = #(MyCoords - button.SpawnPoint)
            if Config.TravelPriceDistance then
                local Calculate = dist * Config.PricePerMeter
                local TravelPrice = math.floor(Calculate)
                local Label = _U('TravelToo') .. button.LocationName .. _U('For') .. TravelPrice
                FastTravelPage1:RegisterElement('button', {
                label = Label,
                style = {
                    ['background-color'] = '#FF8C00',
                    ['color'] = 'orange',
                    ['border-radius'] = '6px'
                },
                }, function()
                local Tp = TravelPrice
                local SpawnCoords = button.SpawnPoint
                local SpawnHeading = button.SpawnHeading
                local LocationName = button.LocationName
                TriggerEvent('mms-fasttravel:client:TravelToo',Tp,SpawnCoords,SpawnHeading,LocationName)
                FastTravel:Close({ 
                })
            end)
            else
                local TravelPrice = button.TravelPrice
                local Label = _U('TravelToo') .. button.LocationName .. _U('For') .. TravelPrice
                 FastTravelPage1:RegisterElement('button', {
                label = Label,
                style = {
                    ['background-color'] = '#FF8C00',
                    ['color'] = 'orange',
                    ['border-radius'] = '6px'
                },
                }, function()
                local Tp = TravelPrice
                local SpawnCoords = button.SpawnPoint
                local SpawnHeading = button.SpawnHeading
                local LocationName = button.LocationName
                TriggerEvent('mms-fasttravel:client:TravelToo',Tp,SpawnCoords,SpawnHeading,LocationName)
                FastTravel:Close({ 
                })
        end)
        end   
        end
        FastTravelPage1:RegisterElement('button', {
            label =  _U('CloseFastTravel'),
            style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
            },
        }, function()
            FastTravel:Close({ 
            })
        end)
        FastTravelPage1:RegisterElement('subheader', {
            value = _U('FastTravelMenuBottom'),
            slot = 'footer',
            style = {
            ['color'] = 'orange',
            }
        })
        FastTravelPage1:RegisterElement('line', {
            slot = 'footer',
            style = {
            ['color'] = 'orange',
            }
        })
        FastTravel:Open({
            startupPage = FastTravelPage1,
        })
    end
end)

RegisterNetEvent('mms-fasttravel:client:TravelToo')
AddEventHandler('mms-fasttravel:client:TravelToo',function(Tp,SpawnCoords,SpawnHeading,LocationName)
    TriggerServerEvent('mms-fasttravel:server:TravelToo',Tp,SpawnCoords,SpawnHeading,LocationName)
end)

RegisterNetEvent('mms-fasttravel:client:TravelToo2')
AddEventHandler('mms-fasttravel:client:TravelToo2',function(Tp,SpawnCoords,SpawnHeading,LocationName)
    AnimpostfxPlayTimed('1p_glassesdark',5000)
    Wait(2000)
    AnimpostfxPlayTimed('cutscene_mar6_train',10000)
    SetEntityCoords(PlayerPedId(),SpawnCoords.x,SpawnCoords.y,SpawnCoords.z -1)
    SetEntityHeading(PlayerPedId(),SpawnHeading)
    Wait(10000)
end)


---- CleanUp on Resource Restart 

RegisterNetEvent('onResourceStop',function(resource)
    if resource == GetCurrentResourceName() then
    for _, npcs in ipairs(CreatedTravelNpcs) do
        npcs:Remove()
	end
    for _, blips in ipairs(CreatedTravelBlips) do
        blips:Remove()
	end
end
end)