local Character     = require('character')
local Torch         = require('torch')
local Camera        = require('camera')
local ObjectsToRender = {}

function love.load()  
    love.graphics.setBackgroundColor( 1, 1, 1 )
    love.graphics.setDefaultFilter("nearest", "nearest")

    localPlayer = Character:Create('assets/player.png', 10.0)    
    cam = Camera( 800, 600, { x = 32, y = 32, resizable = true, maintainAspectRatio = true } )
end

function love.update(dt)
    local playerPos = localPlayer.spriteSheet:GetPos()
    
    if localPlayer ~= nil then
        localPlayer:Update(dt)
    end

    -- On enter place torch ! 
    if love.keyboard.isDown('return') then
        local netTorch = Torch:Create('assets/torch.png')
        netTorch.sprite:SetPos(playerPos)
        table.insert(ObjectsToRender, netTorch)
    end

    -- Update all objects in scene
    for _, object in pairs(ObjectsToRender) do 
        object:Update(dt)
    end

    -- Update camera
    cam:setTranslation(playerPos.x, playerPos.y)
    cam:update() 
end

function love.draw()
    cam:push()
       
        for _, object in pairs(ObjectsToRender) do 
            object:Draw()
        end

        if localPlayer ~= nil then 
            localPlayer:Draw()
        end

    cam:pop()
end