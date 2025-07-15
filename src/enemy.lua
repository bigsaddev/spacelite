-- src/enemy.lua

local Enemy = {}
Enemy.__index = Enemy

function Enemy:new(x, y)
    local obj = {
        x = x or 0,
        y = y or 0,
        speed = 200,
        width = 32,
        height = 32,
        color = { 1, 0, 1 }
    }
    setmetatable(obj, self)
    return obj
end

function Enemy:update(dt)
    self.x = self.x - self.speed * dt
end

function Enemy:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1)
end

return Enemy