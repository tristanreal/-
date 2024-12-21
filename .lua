-- Constants
local groupID = 11648289 -- Replace with your group ID
local bypassUsername = "sub2itr" -- Username to bypass prompt
local requiredPermissionRank = 200 -- Role rank threshold to bypass prompt
local developerProductID = "12345678" -- Replace with your Developer Product ID
local kickMessage = "No early access." -- Message shown when kicked

-- Services
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

-- Function to check player's group rank
local function hasSufficientRank(player)
    local rank = player:GetRankInGroup(groupID)
    return rank >= requiredPermissionRank
end

-- Function to prompt the developer product
local function promptEarlyAccess(player)
    local success, result = pcall(function()
        MarketplaceService:PromptProductPurchase(player, developerProductID)
    end)

    if not success then
        print("Error prompting product purchase: " .. tostring(result))
        player:Kick("An error occurred. Please try again later.")
    end
end

-- PlayerAdded event
Players.PlayerAdded:Connect(function(player)
    -- Bypass conditions
    if player.Name == bypassUsername then
        print(player.Name .. " bypassed the early access prompt.")
        return
    end

    if hasSufficientRank(player) then
        print(player.Name .. " has sufficient rank in the group and bypassed the early access prompt.")
        return
    end

    -- Prompt for early access
    print(player.Name .. " is being prompted for early access.")
    promptEarlyAccess(player)

    -- Wait for a short time to give them a chance to buy
    task.wait(10) -- Adjust wait time if necessary

    -- If they're still in the game and haven't purchased, kick them
    if player and player.Parent then
        print(player.Name .. " did not purchase early access and is being kicked.")
        player:Kick(kickMessage)
    end
end)
