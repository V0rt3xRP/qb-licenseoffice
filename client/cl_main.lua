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
                if Config.Cityhall == true then
                    TriggerEvent('qb-licenses:client:openCityHall')
                else
                    TriggerEvent('qb-licenses:client:openLicencesMenu')
                end
            end
        else
            wait = 2000 
        end
        
        if inZone and not alreadyEnteredZone then
            alreadyEnteredZone = true
            --exports['qb-core']:DrawText(text, 'left')
			exports['textUi']:DrawTextUi('show', text)
        end

        if not inZone and alreadyEnteredZone then
            alreadyEnteredZone = false
            --exports['qb-core']:HideText()
			exports['textUi']:HideTextUi('hide')
        end
        Citizen.Wait(wait)
    end
end)

RegisterNetEvent('qb-licenses:client:openCityHall', function(source, args, raw)
    exports['qb-menu']:openMenu({
        {
            header = "City Hall Job Center",
            isMenuHeader = true
        },
        {
            header = "Job Center",
            txt = "Apply For A Job!",
            params = {
                event = "qb-licenses:client:openJobCenter",
            }
        },
        {
            header = "Buy License",
            txt = "Pick up your licenses!",
            params = {
                event = "qb-licenses:client:openLicencesMenu",
            }
        },
    })
end)

RegisterNetEvent('qb-licenses:client:openJobCenter', function(source, args, raw)
    exports['qb-menu']:openMenu({
        {
            header = "Job Center",
            isMenuHeader = true
        },
        {
            header = "Unemployed",
            hidden = false,
            params = {
                event = "qb-licenses:client:SetJobJobCenter",
                args = {
                    label = 'Unemployed',
                    job = 'unemployed',
                }
            }
        },
        {
            header = "Taxi Driver",
            hidden = false,
            params = {
                event = "qb-licenses:client:SetJobJobCenter",
                args = {
                    label = 'Taxi Driver',
                    job = 'taxi',
                    coords = vector3(901.76, -170.49, 74.08)
                }
            }
        },
        {
            header = "Bus Driver",
            hidden = false,
            params = {
                event = "qb-licenses:client:SetJobJobCenter",
                args = {
                    label = 'Bus Driver',
                    job = 'bus',
                    coords = vector3(462.22, -641.15, 28.44)
                }
            }
        },
        {
            header = "News Reporter",
            hidden = false,
            params = {
                event = "qb-licenses:client:SetJobJobCenter",
                args = {
                    label = 'News Reporter',
                    job = 'reporter',
                    coords = vector3(-601.56, -929.28, 23.86)
                }
            }
        },
        {
            header = "Truck Driver",
            hidden = false,
            params = {
                event = "qb-licenses:client:SetJobJobCenter",
                args = {
                    label = 'Truck Driver',
                    job = 'trucker',
                    coords = vector3(148.91, -3205.2, 5.86)
                }
            }
        },
        {
            header = "Tow Truck Driver",
            hidden = false,
            params = {
                event = "qb-licenses:client:SetJobJobCenter",
                args = {
                    label = 'Tow Truck Driver',
                    job = 'tow',
                    coords = vector3(-191.93, -1162.23, 23.67) -- Gabz Hub
                    -- coords = vector3(489.61, -1312.64, 29.26) -- Haysauto
                }
            }
        },
        {
            header = "Garbage Collecter",
            hidden = false,
            params = {
                event = "qb-licenses:client:SetJobJobCenter",
                args = {
                    label = 'Garbage Collecter',
                    job = 'garbage',
                    coords = vector3(-349.02, -1541.59, 27.72)
                }
            }
        },
        {
            header = "Hotdog Stand",
            hidden = false,
            params = {
                event = "qb-licenses:client:SetJobJobCenter",
                args = {
                    label = 'Hotdog Stand',
                    job = 'hotdog',
                    coords = vector3(39.24, -1005.53, 29.48)
                }
            }
        }
    })
end)
 
RegisterNetEvent('qb-licenses:client:SetJobJobCenter', function(data)
    TriggerServerEvent('qb-licenses:server:SetJobJobCenter', data)
    SetNewWaypoint(coords)
end)

RegisterNetEvent('qb-licenses:client:openLicencesMenu', function(source, args, raw)
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
end)

RegisterNetEvent('qb-licenses:client:requestId', function(data)
    TriggerServerEvent('qb-licenses:server:requestId', data.item, data.cost)
end)