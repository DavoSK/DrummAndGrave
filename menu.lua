Menu = {}
Menu.__index = Menu 

function Menu:Create(title, options, onChoose)
    local newMenu = {}
    setmetatable(newMenu, Menu)
    newMenu.options = options
    newMenu.title = title
    newMenu.activeOption = 1
    newMenu.active = true
    newMenu.onChoose = onChoose

    newMenu.titleFont = love.graphics.newFont("assets/ARCADECLASSIC.TTF", 50)
    newMenu.optionsFont = love.graphics.newFont("assets/ARCADECLASSIC.TTF", 18)
    return newMenu
end

function Menu:Update(deltaTime)

end

function Menu:OnKeyPressed(key) 
    if key == 'return' and self.onChoose ~= nil then
        self.onChoose(self.activeOption)
    end

    if key == 'down' then
        if self.activeOption + 1 > #self.options then
            self.activeOption = 1
        else 
            self.activeOption = self.activeOption + 1
        end
    end

    if key == 'up' then 
        if self.activeOption - 1 < 1 then
            self.activeOption = #self.options
        else
            self.activeOption = self.activeOption - 1
        end
    end
end

function Menu:Draw() 

    if not self.active then
        return
    end

    local startY = 300
    local spaceHeight = 30
    local activeColor = {r = 0, g = 1, b = 1}
    local normalColor = {r = 1, g = 1, b = 1}
    local width = love.graphics:getWidth()

    love.graphics.setFont(self.titleFont)
    love.graphics.setColor(normalColor.r, normalColor.g, normalColor.b, 1)

    local textWidth = self.titleFont:getWidth(self.title)
    love.graphics.print(self.title,  (width / 2) - (textWidth / 2), startY)
    startY = startY + self.titleFont:getHeight() + spaceHeight
    love.graphics.setFont(self.optionsFont)

    for i = 1, #self.options do 
        local option = self.options[i]
        if option then
            if i == self.activeOption then 
                love.graphics.setColor(activeColor.r, activeColor.g, activeColor.b, 1)
            else 
                love.graphics.setColor(normalColor.r, normalColor.g, normalColor.b, 1)
            end
            
            textWidth = self.optionsFont:getWidth(option)
            love.graphics.print(option, (width / 2) - (textWidth / 2), startY)
            startY = startY + self.optionsFont:getHeight() + spaceHeight
        end
    end
    love.graphics.setColor(normalColor.r, normalColor.g, normalColor.b, 1)
end

return Menu