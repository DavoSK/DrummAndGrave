Torch = {}
Torch.__index = Torch

local Sprite = require('sprite')

function Torch:Create(atlasFile)
    local newTorch = {}
    setmetatable(newTorch, Torch)
    newTorch.sprite = Sprite:CreateAnimated(atlasFile, 8, 0.1)
    newTorch.sprite.scale = 8
    newTorch.sprite:SetBoundaries(1, 4)
    newTorch.lightMask = love.graphics.newImage('assets/light_mask.png')
    newTorch.castedLightColor = {r = 1, g = 1, b = 1 }
    newTorch.pulseTime = 0
    return newTorch
end

function Torch:Draw()
    
    -- get center of cone
    local coneScale = 1.05 + 0.5 * math.sin(3 * self.pulseTime)
    local conePosition = {
        x = self.sprite.position.x - (self.lightMask:getWidth() * coneScale) / 2 +  (8 * self.sprite.scale) / 2,
        y = self.sprite.position.y - (self.lightMask:getHeight() * coneScale) / 2  +  (8 * self.sprite.scale) / 2
    }

    -- Draw casted light
    r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(self.castedLightColor.r, self.castedLightColor.g, self.castedLightColor.b)
    love.graphics.draw (self.lightMask, conePosition.x, conePosition.y, 0, coneScale, coneScale, 0, 0)
    love.graphics.setColor(r, g, b, a)

    -- Draw torch sprite
    self.sprite:Draw()
end

function Torch:Update(deltaTime)
    self.sprite:Update(deltaTime)
    self.pulseTime = self.pulseTime + deltaTime
end

return Torch