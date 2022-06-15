QBCore = exports['qb-core']:GetCoreObject()


RegisterNetEvent('qb-licenses:server:requestId', function(item, cost)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player.Functions.RemoveMoney("cash", cost) then return TriggerClientEvent('QBCore:Notify', src, ('You don\'t have enough money on you, you need %s cash'):format(cost), 'error') end
    local info = {}
    if item == "id_card" then
        info.citizenid = Player.PlayerData.citizenid
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.gender = Player.PlayerData.charinfo.gender
        info.nationality = Player.PlayerData.charinfo.nationality
    elseif item == "driver_license" then
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.type = "Class C Driver License"
    elseif item == "weaponlicense" then
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
    elseif item == "huntinglicense" then -- added for hunting
        info.citizenid = Player.PlayerData.citizenid
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.gender = Player.PlayerData.charinfo.gender
    elseif item == "fishinglicense" then -- added for fishing
        info.citizenid = Player.PlayerData.citizenid
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.gender = Player.PlayerData.charinfo.gender
    end
    if not Player.Functions.AddItem(item, 1, nil, info) then return end
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add')
end)

QBCore.Functions.CreateCallback('qb-licenses:server:checkLicences', function(source,cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local driver =  Player.PlayerData.metadata['licences']['driver']
    local weapon =  Player.PlayerData.metadata['licences']['weapon']
    local hunting =  Player.PlayerData.metadata['licences']['hunting']
    local fishing =  Player.PlayerData.metadata['licences']['fishing']
        cb(driver, weapon, hunting, fishing)
end)

RegisterNetEvent('qb-licenses:server:SetJobJobCenter', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.SetJob(data.job, 0) then
        TriggerClientEvent('QBCore:Notify', src, 'Changed your job to: '..data.job)
    end
end)