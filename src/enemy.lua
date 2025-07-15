-- src/enemy.lua

local Enemy = {}
Enemy.__index = Enemy

function Enemy:new(x, y, w, h)
    local obj = {
        x = x or 0,
        y = y or 0,
        speed = 600,
        width = w or 32,
        height = h or 32,
        sprite = love.graphics.newImage("assets/sprites/enemy1.png"),
        isDead = false,
        health = 1
    }
    setmetatable(obj, self)
    return obj
end

function Enemy:update(dt)
    self.x = self.x - self.speed * dt
end

function Enemy:draw()
    if not self.isDead then
        love.graphics.draw(self.sprite, self.x, self.y)
    end
end

function Enemy:takeDamage(amount)
    self.health = self.health - amount
    if self.health <= 0 then
        self.isDead = true
    end
end

return Enemy