Torch = {}
Torch.__index = Torch

local Sprite = require('sprite')

function Torch:Create(atlasFile)
    local newTorch = {}
    setmetatable(newTorch, Torch)
    newTorch.sprite = Sprite:CreateAnimated(atlasFile, 8, 0.1)
    newTorch.sprite.scale = GlobalScale
    newTorch.sprite:SetBoundaries(5, 8)
    newTorch.lightMask = love.graphics.newImage('assets/light_mask.png')
    newTorch.castedLightColor = {r = 1, g = 1, b = 1 }
    newTorch.pulseTime = 0
    return newTorch
end

function Torch:GetPos()
    return self.sprite.position
end

function Torch:SetPos(pos) 
    self.sprite.position = pos
end

function Torch:Draw()
    self.sprite:Draw()
end

function Torch:Update(deltaTime)
    self.sprite:Update(deltaTime)
    self.pulseTime = self.pulseTime + deltaTime
end

return Torch