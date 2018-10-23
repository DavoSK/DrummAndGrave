GlobalScale = 5

local Scene         = require('scene')
local Character     = require('character')
local Torch         = require('torch')
local Camera        = require('camera')
local Lights        = require('lights')
local Menu          = require('menu')
local Map           = require('map')

function love.load()  
    love.graphics.setBackgroundColor( 0, 0, 0 )
    love.graphics.setDefaultFilter("nearest", "nearest")

    mainScene = Scene:Create()
    localPlayer = Character:Create('assets/player.png', GlobalScale)    
    mainScene:AddObject(localPlayer, 2)

    mainMap = Map:Load('assets/maps/map_tristram', function(spritePos, tileId)     
        if tileId == 110 then
            localPlayer.spriteSheet.position = spritePos
            localPlayer.position = spritePos
            return 0
        end
        return tileId
    end)

    cam = Camera(800, 600, { x = 32, y = 32, resizable = true, maintainAspectRatio = true } )
    Lights:Init()

    mainMenuLogo = love.graphics.newImage('assets/logo.jpg')
    mainMenu = Menu:Create('Drumm and Grave', {'New Game',
                                               'Options',
                                               'Exit Game'
    }, function(option)
        mainMenu.active = false
    end)
end

function love.keypressed(key, scancode, isrepeat)
    mainMenu:OnKeyPressed(key)
end

function love.update(dt)
    local playerPos = localPlayer.spriteSheet:GetPos()
    if love.keyboard.isDown('return') then
        local newTorch = Torch:Create('assets/torch.png')
        newTorch:SetPos(playerPos)
        Lights:Add(playerPos, {r =  0.984, g = 0.772, b = 0.533}, 20)
        mainScene:AddObject(newTorch)
    end

    mainScene:Update(dt)
    mainMap:Update(dt)
    mainMenu:Update(dt)

    cam:setTranslation(playerPos.x, playerPos.y)
    cam:update() 
end

function love.draw()

    Lights:Draw(cam) 
    cam:push()
        mainMap:Draw()
        mainScene:Draw()
    cam:pop()
    
    love.graphics.setShader()

    if mainMenu.active then
        local windowWidth = love.graphics:getWidth()
        local logoWidth = mainMenuLogo:getWidth()
        love.graphics.draw(mainMenuLogo, (windowWidth / 2) - (logoWidth / 2), 10)
        mainMenu:Draw()
    end
end