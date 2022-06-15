QBCore = exports['qb-core']:GetCoreObject()

AddEventHandler('onResourceStart', function (resource)
    if resource == GetCurrentResourceName() then
        CreateBlip()
    end
end)

function CreateBlip()
    if Config.useBlip == true then
        cityHallBlip = AddBlipForCoord(Config.Location)
        SetBlipSprite (cityHallBlip, 183)
        SetBlipDisplay(cityHallBlip, 4)
        SetBlipScale  (cityHallBlip, 0.6)
        SetBlipAsShortRange(cityHallBlip, true)
        SetBlipColour(cityHallBlip, 0)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName('City Hall')
        EndTextCommandSetBlipName(cityHallBlip)
    end
end


Citizen.CreateThread(function()
    local alreadyEnteredZone = false
    local text = nil
    while true do
        wait = 5
        local ped = PlayerPedId()
        local inZone = false
        local dist = #(GetEntityCoords(ped)-Config.Location)
        if dist <= 2.0 then
            wait = 5
            inZone  = true
            text = '[E] City Services Menu'

            if IsControlJustReleased(0, 38) then
                openLicencesMenu()
            end
        else
            wait = 2000 
        end
        
        if inZone and not alreadyEnteredZone then
            alreadyEnteredZone = true
            exports['qb-core']:DrawText(text, 'left')
        end

        if not inZone and alreadyEnteredZone then
            alreadyEnteredZone = false
            exports['qb-core']:HideText()
        end
        Citizen.Wait(wait)
    end
end)

function openLicencesMenu(source, args, raw)
    QBCore.Functions.TriggerCallback('qb-licenses:server:checkLicences', function(driver, weapon, hunting, fishing)
        exports['qb-menu']:openMenu({
            {
                header = "City Hall License Office",
                isMenuHeader = true
            },
            {
                header = "ID Card",
                txt = "Pay - $250",
                params = {
                    event = "qb-licenses:client:requestId",
                    args = {
                        item = 'id_card',
                        cost = '250'
                    }
                }
            },
            {
                header = "Driving License",
                txt = "Pay - $250",
                hidden = driver == false,
                params = {
                    event = "qb-licenses:client:requestId",
                    args = {
                        item = 'driver_license',
                        cost = '250'
                    }
                }
            },
            {
                header = "Weapons License",
                txt = "Pay - $5000",
                hidden = weapon == false,
                params = {
                    event = "qb-licenses:client:requestId",
                    args = {
                        item = 'weaponlicense',
                        cost = '5000'
                    }
                }
            },
            {
                header = "Hunting License",
                txt = "Pay - $5000",
                hidden = hunting == false,
                params = {
                    event = "qb-licenses:client:requestId",
                    args = {
                        item = 'huntinglicense',
                        cost = '5000'
                    }
                }
            },
            {
                header = "Fishing License",
                txt = "Pay - $5000",
                hidden = fishing == false,
                params = {
                    event = "qb-licenses:client:requestId",
                    args = {
                        item = 'fishinglicense',
                        cost = '5000'
                    }
                }
            },
        })
    end)
end

RegisterNetEvent('qb-licenses:client:requestId', function(data)
    TriggerServerEvent('qb-licenses:server:requestId', data.item, data.cost)
end)