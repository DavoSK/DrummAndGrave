--[[
    Simple impplementation of character in game 
    character is basicaly animated sprite binded on simple input of keyboard
    DavoSK 2018
]]--

Character = {}
Character.__index = Character

local Sprite = require('sprite')

function Character:Create(spriteSheetFile, size) 

    local newCharacter = {}
    setmetatable(newCharacter, Character)

    newCharacter.spriteSheet = Sprite:CreateAnimated(spriteSheetFile, 8, 0.1)
    newCharacter.spriteSheet.scale = size
    newCharacter.speed = 150.0
    newCharacter.jump = {
        speed = 100.0,
        jumping = false,
        jumpHeight = 20.0,
        jumpStart = nil
    }

    newCharacter.position = {
        x = 0.0,
        y = 0.0 
    } 

    newCharacter.velocity = {
        x = 0.0,
        y = 0.0
    }

    return newCharacter
end

function Character:Draw()   
    self.spriteSheet:Draw();
end

function Character:UpdateAnimState()

    local animationIdxStart = 0
    local animationIdxEnd = 0

    if self.velocity.y < 0.0 then
        animationIdxStart = 5
        animationIdxEnd = 8
    end

    if self.velocity.y > 0.0 then
        animationIdxStart = 9
        animationIdxEnd = 12
    end

    if self.velocity.x > 0.0 then
        
        animationIdxStart = 9
        animationIdxEnd = 12

        if self.velocity.y < 0.0 then
            animationIdxStart = 5
            animationIdxEnd = 8
        end
    end

    if self.velocity.x < 0.0 then
        animationIdxStart = 1
        animationIdxEnd = 4

        if self.velocity.y < 0.0 then
            animationIdxStart = 13
            animationIdxEnd = 16
        end
    end

    self.spriteSheet:SetBoundaries(animationIdxStart, animationIdxEnd)
end

function Character:Update(deltaTime)

    local yDirectionChange = false
    local xDirectionChange = false

    if love.keyboard.isDown('w') and not self.jump.jumping then 
        self.velocity.y = -self.speed
        yDirectionChange = true
    end

    if love.keyboard.isDown('a') then
        self.velocity.x = -self.speed
        xDirectionChange = true
    end

    if love.keyboard.isDown('s') and not self.jump.jumping then 
        self.velocity.y = self.speed
        yDirectionChange = true
    end

    if love.keyboard.isDown('d') then
        self.velocity.x = self.speed
        xDirectionChange = true
    end

    if love.keyboard.isDown('space') then
        if not self.jump.jumping then
            self.jump.jumpStart = self.position.y
            self.velocity.y = -self.jump.speed
            self.jump.jumping = true
        end
    end

    if not xDirectionChange then
        self.velocity.x = 0.0
    end

    if not yDirectionChange and not self.jump.jumping then
        self.velocity.y = 0.0
    end

    self.position = {
        x = self.position.x + (self.velocity.x * deltaTime),
        y = self.position.y + (self.velocity.y * deltaTime)
    }

    if self.jump.jumping then
        if self.position.y < self.jump.jumpStart - self.jump.jumpHeight then 
            self.velocity.y = self.jump.speed
        end

        if self.position.y >= self.jump.jumpStart + 0.05 then
            self.jump.jumping = false
            self.velocity.y = 0
        end
    end

    if self.spriteSheet ~= nil then
        self.spriteSheet:SetPos(self.position)

        if (self.velocity.x ~= 0.0 or self.velocity.y ~= 0.0) and not self.jump.jumping then
            self:UpdateAnimState()
            self.spriteSheet:Update(deltaTime)
        else
            self.spriteSheet.frameId = self.spriteSheet.frameStartId
        end
    end
end

return Character