local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players, RunService = game:GetService("Players"), game:GetService("RunService")

-- Create UI Window
local Window = Rayfield:CreateWindow({
   Name = "anim changers",
   Icon = Radiation,
   LoadingTitle = "anim changerz by michael",
   LoadingSubtitle = "minkemonke",
   Theme = "Amethyst",
   DisableRayfieldPrompts = true,
   DisableBuildWarnings = true,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "michaelconfigs"
   },
   KeySystem = true,
   KeySettings = {
      Title = "michaelkeysystemfr",
      Subtitle = "nyehehehehe",
      Note = "jk im not gonna make you go thru some bs, key's michaelhateskeys",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"michaelhateskeys"}
   }
})

local Tab = Window:CreateTab("the actual changers", baby)

-- Animation Overrides (Replaces Normal's Run Animation)
local normalRunAnim = "rbxassetid://136252471123500"
local animationOverrides = {
    ["rbxassetid://136252471123500"] = "rbxassetid://105276039560",
    ["rbxassetid://136252471123500"] = "rbxassetid://798789321448"
}

local selectedOption = "Normal" -- Default (no override)
local blockedAnimations = {} -- Will only be updated when a replacement is chosen

-- Dropdown UI
local Dropdown = Tab:CreateDropdown({
   Name = "Run Animations",
   Options = {"Normal", "Knight", "Khaled"},
   CurrentOption = "Normal",
   MultipleOptions = false,
   Flag = "Dropdown1",
   Callback = function(Option)
      selectedOption = Option[1] -- Update selected animation type
      print("Selected animation type:", selectedOption)

      -- Update blockedAnimations: Only block normal when an override is active
      blockedAnimations = selectedOption ~= "Normal" and {[normalRunAnim] = true} or {}
   end,
})

-- Function to replace animations
local function replaceAnimation(animationTrack)
    if selectedOption ~= "Normal" and animationTrack.Animation.AnimationId == normalRunAnim then
        local newAnimId = animationOverrides[selectedOption]
        if newAnimId then
            local anim = Instance.new("Animation")
            anim.AnimationId = newAnimId
            local loadedAnim = humanoid:LoadAnimation(anim)
            loadedAnim.Priority = Enum.AnimationPriority.Action2
            loadedAnim:Play()
        end
    end
end

-- Function to stop blocked animations
local function stopBlockedAnimations(humanoid)
    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
        if blockedAnimations[track.Animation and track.Animation.AnimationId] then track:Stop() end
    end
end

local function onCharacterAdded(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local connection; connection = RunService.Heartbeat:Connect(function()
            if character.Parent then stopBlockedAnimations(humanoid) else connection:Disconnect() end
        end)
    end
end

local function onPlayerAdded(player)
    player.CharacterAdded:Connect(onCharacterAdded)
    if player.Character then onCharacterAdded(player.Character) end
end

Players.PlayerAdded:Connect(onPlayerAdded)
for _, player in ipairs(Players:GetPlayers()) do onPlayerAdded(player) end

pcall(function()
    if getgenv().animationHook then getgenv().animationHook:Disconnect() end
end)

getgenv().animationHook = humanoid.AnimationPlayed:Connect(replaceAnimation)
