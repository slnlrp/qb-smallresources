local VehicleNitrous = {}

RegisterNetEvent('tackle:server:TacklePlayer', function(playerId)
    TriggerClientEvent("tackle:client:GetTackled", playerId)
end)

QBCore.Functions.CreateCallback('nos:GetNosLoadedVehs', function(source, cb)
    cb(VehicleNitrous)
end)

QBCore.Commands.Add("id", "Check Your ID #", {}, false, function(source, args)
    local src = source
    TriggerClientEvent('QBCore:Notify', src, "ID: " .. src)
end)

QBCore.Functions.CreateUseableItem("harness", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent('seatbelt:client:UseHarness', src, item)
end)

RegisterNetEvent('equip:harness', function(item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.items[item.slot].info.uses - 1 == 0 then
        TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items['harness'], "remove")
        Player.Functions.RemoveItem('harness', 1)
    else
        Player.PlayerData.items[item.slot].info.uses = Player.PlayerData.items[item.slot].info.uses - 1
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
end)

RegisterNetEvent('seatbelt:DoHarnessDamage', function(hp, data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if hp == 0 then
        Player.Functions.RemoveItem('harness', 1, data.slot)
    else
        Player.PlayerData.items[data.slot].info.uses = Player.PlayerData.items[data.slot].info.uses - 1
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
end)

RegisterNetEvent('qb-carwash:server:washCar', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player.Functions.RemoveMoney('cash', Config.DefaultPrice, "car-washed") then
        TriggerClientEvent('qb-carwash:client:washCar', src)
    elseif Player.Functions.RemoveMoney('bank', Config.DefaultPrice, "car-washed") then
        TriggerClientEvent('qb-carwash:client:washCar', src)
    else
        TriggerClientEvent('QBCore:Notify', src, 'You dont have enough money..', 'error')
    end
end)

QBCore.Functions.CreateCallback('smallresources:server:GetCurrentPlayers', function(source, cb)
    local TotalPlayers = 0
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        TotalPlayers = TotalPlayers + 1
    end
    cb(TotalPlayers)
end)

QBCore.Commands.Add("id", "Check Your ID #", {}, false, function(source, args)
    local src = source
    TriggerClientEvent('QBCore:Notify', src, "ID: " .. src)
end)

QBCore.Commands.Add("addrep", "Add Reputation to a Player", {{
    name = "id",
    help = "ID of player"
}, {
    name = "type",
    help = "dealer/crafting/atcrafting"
}, {
    name = "amount",
    help = "Amount of Rep"
}}, false, function(source, args)

    local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))

    if Player ~= nil then
        if args[1] ~= nil and args[2] ~= nil and args[3] ~= nil then
            local x = tonumber(args[1])
            local y = args[2]
            local z = tonumber(args[3])

            if y == "dealer" then
                local newrep = Player.PlayerData.metadata["dealerrep"] + z
                Player.Functions.SetMetaData("dealerrep", newrep)
                TriggerClientEvent('QBCore:Notify', source, "Dealer Reputation Added")
            end
            if y == "crafting" then
                local newrep = Player.PlayerData.metadata["craftingrep"] + z
                Player.Functions.SetMetaData("craftingrep", newrep)
                TriggerClientEvent('QBCore:Notify', source, "Crafting Reputation Added")
            end
            if y == "atcrafting" then
                local newrep = Player.PlayerData.metadata["attachmentcraftingrep"] + z
                Player.Functions.SetMetaData("attachmentcraftingrep", newrep)
                TriggerClientEvent('QBCore:Notify', source, "Attachment Crafting Reputation Added")
            end
        else
            TriggerClientEvent('QBCore:Notify', source, "Not every argument has been entered.", "error")
        end
    else
        TriggerClientEvent('QBCore:Notify', source, "Player not Online.", "error")
    end
end, "god") -- change allowed role here 

-- DELETE PLAYER's ENTIRE REP 
QBCore.Commands.Add("deleterep", "Delete all Reputation to a Player", {{
    name = "id",
    help = "ID of player"
}, {
    name = "type",
    help = "dealer/crafting/atcrafting"
}}, false, function(source, args)

    local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))

    if Player ~= nil then
        if args[1] ~= nil and args[2] ~= nil then
            local x = tonumber(args[1])
            local y = args[2]

            if y == "dealer" then
                Player.Functions.SetMetaData("dealerrep", 0)
                TriggerClientEvent('QBCore:Notify', source, 'Cleared ALL Dealer-Rep of ID ' .. x .. '')
            end
            if y == "crafting" then
                Player.Functions.SetMetaData("craftingrep", 0)
                TriggerClientEvent('QBCore:Notify', source, 'Cleared ALL Crafting-Rep of ID ' .. x .. '')
            end
            if y == "atcrafting" then
                Player.Functions.SetMetaData("attachmentcraftingrep", 0)
                TriggerClientEvent('QBCore:Notify', source, 'Cleared ALL At-Rep of ID ' .. x .. '')
            end
        else
            TriggerClientEvent('QBCore:Notify', source, "Not every argument has been entered.", "error")
        end
    else
        TriggerClientEvent('QBCore:Notify', source, "Player not Online.", "error")
    end
end, "god") -- change allowed role here 

-- CHECK REP OF ANY ONLINE PLAYER (ADMIN ONLY)
QBCore.Commands.Add("checkrep", "Check Reputation of a Player", {{
    name = "id",
    help = "ID of player"
}, {
    name = "type",
    help = "dealer/crafting/atcrafting"
}}, false, function(source, args)

    local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))

    if Player ~= nil then
        if args[1] ~= nil and args[2] ~= nil then
            local x = tonumber(args[1])
            local y = args[2]

            if y == "dealer" then
                local newrep = Player.PlayerData.metadata["dealerrep"]
                TriggerClientEvent('QBCore:Notify', source, 'Current Dealer-Rep of ID ' .. x .. ' is ' .. newrep .. '')
            end
            if y == "crafting" then
                local newrep = Player.PlayerData.metadata["craftingrep"]
                TriggerClientEvent('QBCore:Notify', source, 'Current Crafting-Rep of ID ' .. x .. ' is ' .. newrep .. '')
            end
            if y == "atcrafting" then
                local newrep = Player.PlayerData.metadata["attachmentcraftingrep"]
                TriggerClientEvent('QBCore:Notify', source, 'Current At-Rep of ID ' .. x .. ' is ' .. newrep .. '')
            end
        else
            TriggerClientEvent('QBCore:Notify', source, "Not every argument has been entered.", "error")
        end
    else
        TriggerClientEvent('QBCore:Notify', source, "Player not Online.", "error")
    end
end, "admin") -- change allowed role here 

-- CHECK PLAYER OWN REPS (ALL IN ONE MESSAGE)
QBCore.Commands.Add("myrep", "Check Your Reputations", {}, false, function(source, args)

    local Player = QBCore.Functions.GetPlayer(source)

    if Player ~= nil then

        local x = Player.PlayerData.metadata["dealerrep"]
        local y = Player.PlayerData.metadata["craftingrep"]
        local z = Player.PlayerData.metadata["attachmentcraftingrep"]

        TriggerClientEvent('QBCore:Notify', source, 'Your Current Dealer Reputation: ' .. x .. '')
        TriggerClientEvent('QBCore:Notify', source, 'Your Current Crafting Reputation: ' .. y .. '')
        TriggerClientEvent('QBCore:Notify', source, 'Your Current Attachment Reputation: ' .. z .. '')

    else
        TriggerClientEvent('QBCore:Notify', source, "Player not Online.", "error")
    end
end)

-- GIVE YOUR REPUTATION TO OTHER PLAYERS

QBCore.Commands.Add("giverep", "Add Reputation to a Player", {{
    name = "id",
    help = "ID of player"
}, {
    name = "type",
    help = "dealer/crafting/atcrafting"
}, {
    name = "amount",
    help = "Amount of Rep"
}}, false, function(source, args)

    local Self = QBCore.Functions.GetPlayer(source)
    local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))

    if Player ~= nil and Self ~= nil then
        if args[1] ~= nil and args[2] ~= nil and args[3] ~= nil then
            local x = tonumber(args[1])
            local y = args[2]
            local z = tonumber(args[3])
            if z > 0 then
                if y == "dealer" and Self.PlayerData.metadata["dealerrep"] >= z then
                    local selfrep = Self.PlayerData.metadata["dealerrep"] - z
                    local newrep = Player.PlayerData.metadata["dealerrep"] + z
                    Player.Functions.SetMetaData("dealerrep", newrep)
                    Self.Functions.SetMetaData("dealerrep", selfrep)
                    TriggerClientEvent('QBCore:Notify', source, "You received some DEALER REP.", "success")
                end
                if y == "crafting" and Self.PlayerData.metadata["craftingrep"] >= z then
                    local selfrep = Self.PlayerData.metadata["craftingrep"] - z
                    local newrep = Player.PlayerData.metadata["craftingrep"] + z
                    Player.Functions.SetMetaData("craftingrep", newrep)
                    Self.Functions.SetMetaData("craftingrep", selfrep)
                    TriggerClientEvent('QBCore:Notify', source, "You received some CRAFTING REP.", "success")
                end
                if y == "atcrafting" and Self.PlayerData.metadata["attachmentcraftingrep"] >= z then
                    local selfrep = Self.PlayerData.metadata["attachmentcraftingrep"] - z
                    local newrep = Player.PlayerData.metadata["attachmentcraftingrep"] + z
                    Player.Functions.SetMetaData("attachmentcraftingrep", newrep)
                    Self.Functions.SetMetaData("attachmentcraftingrep", selfrep)
                    TriggerClientEvent('QBCore:Notify', source, "You received some ATTACHMENT CRAFTING REP.", "success")
                end
            else
                TriggerClientEvent('QBCore:Notify', source, "Negative Values not Allowed.", "error")
            end
        else
            TriggerClientEvent('QBCore:Notify', source, "Not every argument has been entered.", "error")
        end
    else
        TriggerClientEvent('QBCore:Notify', source, "Player not Online.", "error")
    end
end)

