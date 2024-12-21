-- Constants
local groupID = 11648289 -- Replace with your group ID
local bypassUsername = "sub2itr" -- Username to bypass prompt
local requiredPermissionRank = 200 -- Role rank threshold to bypass prompt
local banlandRank = 1 -- Rank indicating "banlanded" status
local banlandPlaceID = 12345678 -- Replace with your Banland game place ID
local gamePassID = 12345678 -- Replace with your Game Pass ID
local kickMessage = "No early access." -- Message shown when kicked

-- Services
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local TeleportService = game:GetService("TeleportService")

-- Function to check player's group rank
local function getPlayerRank(player)
    return player:GetRankInGroup(groupID)
end

-- Function to check if player owns the Game Pass
local function hasGamePass(player)
    local success, result = pcall(function()
        return MarketplaceService:UserOwnsGamePassAsync(player.UserId, gamePassID)
    end)

    if not success then
        warn("Error checking Game Pass ownership for " .. player.Name .. ": " .. tostring(result))
        return false
    end

    return result
end

-- Function to teleport to Banland
local function teleportToBanland(player)
    local success, result = pcall(function()
        TeleportService:Teleport(banlandPlaceID, player)
    end)

    if not success then
        warn("Failed to teleport " .. player.Name .. " to Banland: " .. tostring(result))
        player:Kick("Unable to teleport to Banland. Please rejoin.")
    end
end

-- PlayerAdded event
Players.PlayerAdded:Connect(function(player)
    local rank = getPlayerRank(player)

    -- Banland check
    if rank == banlandRank then
        print(player.Name .. " is ranked 'banlanded' and will be teleported to Banland.")
        teleportToBanland(player)
        return
    end

    -- Bypass conditions
    if player.Name == bypassUsername then
        print(player.Name .. " bypassed the early access requirement.")
        return
    end

    if rank >= requiredPermissionRank then
        print(player.Name .. " has sufficient rank in the group and bypassed the early access requirement.")
        return
    end

    -- Check Game Pass ownership
    if hasGamePass(player) then
        print(player.Name .. " owns the Early Access Game Pass and is allowed access.")
        return
    end

    -- If none of the conditions are met, kick the player
    print(player.Name .. " does not meet the early access requirements and is being kicked.")
    player:Kick(kickMessage)
end)
