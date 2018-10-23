--[[

Tiled map renderer
Needs improovments:
    ->
]]

Map = {}
Map.__index = Map 

local Sprite = require('sprite')

function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function Map:Load(mapFileName, onTileLoad)
    local newMap = {}
    setmetatable(newMap, Map)
    newMap.tiledMap = require(mapFileName)
    
    for i = 1, #newMap.tiledMap.tilesets do
        local newAtlas = Sprite:CreateAnimated('assets/' .. split(newMap.tiledMap.tilesets[i].image, '/')[2], 
        newMap.tiledMap.tilesets[i].tilewidth, 0.1)
        newAtlas.scale = GlobalScale
        newMap.tiledMap.tilesets[i].loveImg = newAtlas
    end

    local map = newMap.tiledMap
    for i = 1, #map.layers do 
        newMap:DrawLayer(map.layers[i], onTileLoad)
    end
    
    return newMap
end

function Map:GetTileSetFromGID(gid) 
    for i = 1, #self.tiledMap.tilesets do
        local tileSet = self.tiledMap.tilesets[i]
        if gid >= tileSet.firstgid and gid <= tileSet.firstgid + tileSet.tilecount then
            return tileSet        
        end
    end
    return nil
end

function Map:DrawLayer(layer, onTileDrawn) 
    local tileIdx = 1
    for y = 1, layer.height do 
        for x = 1, layer.width do 
            local tileId = layer.data[tileIdx]
            local tileSet = self:GetTileSetFromGID(tileId)
            if tileSet ~= nil then
                local spriteSheetIndex = (tileId - tileSet.firstgid) + 1
                local sprite = tileSet.loveImg

                if sprite ~= nil then
                    local spritePos = {x = x * ( 8 * sprite.scale), y = y * ( 8 * sprite.scale)}
                    if onTileDrawn ~= nil then
                        layer.data[tileIdx] = onTileDrawn(spritePos, tileId) 
                    end

                    sprite:SetPos(spritePos)
                    if spriteSheetIndex <= #sprite.quads then
                        sprite:SetBoundaries(spriteSheetIndex, spriteSheetIndex)
                    end
                    sprite:Draw()
                end
            end
            tileIdx = tileIdx + 1
        end
    end
end

function Map:Draw()
    local map = self.tiledMap
    for i = 1, #map.layers do 
        self:DrawLayer(map.layers[i], nil)
    end
end

function Map:Update(deltaTime)
end

return Map
