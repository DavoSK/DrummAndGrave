Scene = {}
Scene.__index = Scene

function Scene:Create() 
    local newScene = {}
    setmetatable(newScene, Scene)
    newScene.objects = {}
    newScene.biggestZIndex = 1
    return newScene
end

function Scene:AddObject(object, zindex)
    object.zindex = zindex or 1
    table.insert(self.objects, object)

    if object.zindex > self.biggestZIndex then
        self.biggestZIndex = self.biggestZIndex + 1
    end
end

function Scene:RemoveObject(object)
    table.remove(self.objects, object)
end

function Scene:Draw()
    for i = 1, self.biggestZIndex do 
        for _, object in pairs(self.objects) do
            if object.zindex == i then
                object:Draw()
            end
        end
    end
end

function Scene:Update(deltaTime)
    for _, object in pairs(self.objects) do 
        object:Update(deltaTime)
    end
end

return Scene