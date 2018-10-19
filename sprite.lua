Sprite = {}
Sprite.__index = Sprite

function Sprite:Create(imageFile) 
    self.image = love.graphics.newImage(imageFile)
    self.animated = false
    self.scale = 5.0
    self.position = {
        x = 0.0,
        y = 0.0
    }
    return self
end

function Sprite:CreateAnimated(imageFile, tileSize, duration) 

    local newSprite = {}
    setmetatable(newSprite, Sprite)

    newSprite.image = love.graphics.newImage(imageFile)
    newSprite.duration = duration or 1
    newSprite.tileSize = tileSize
    newSprite.lastTime = love.timer.getTime()
    newSprite.frameId = 1
    newSprite.frameStartId = 1
    newSprite.frameEndId = 1
    newSprite.scale = 5.0
    newSprite.quads = {};

    for y = 0, newSprite.image:getHeight() - tileSize, tileSize do
        for x = 0, newSprite.image:getWidth() - tileSize, tileSize do
            table.insert(newSprite.quads, love.graphics.newQuad(x, y, tileSize, tileSize, newSprite.image:getDimensions()))
        end
    end

    newSprite.position = {
        x = 0.0,
        y = 0.0
    }

    newSprite.animated = true
    return newSprite
end

function Sprite:SetPos(pos) 
    self.position = pos
end

function Sprite:GetPos()
    return self.position
end

function Sprite:SetBoundaries(startFrameIdx, endFrameIdx)
    
    if self.frameStartId ~= startFrameIdx or self.frameEndId ~= endFrameIdx then 
        self.frameId = startFrameIdx
    end

    self.frameStartId = startFrameIdx
    self.frameEndId = endFrameIdx
end

function Sprite:Draw()
    if self.image ~= nil and not self.animated then
        love.graphics.draw(self.image, self.position.x, self.position.y, 0, self.scale, self.scale, 0, 0)
    end

    if self.image ~= nil and self.animated then
        love.graphics.draw(self.image, self.quads[self.frameId], self.position.x, self.position.y, 0, self.scale, self.scale, 0, 0, 0, 0)
    end
end

function Sprite:Update(deltaTime)
    if self.image ~= nil and self.animated then
        if (love.timer.getTime() - self.lastTime) > self.duration then
            if self.frameId + 1 > self.frameEndId then
                self.frameId = self.frameStartId
            else
                self.frameId = self.frameId + 1
            end

            self.lastTime = love.timer.getTime()
        end
    end
end

return Sprite