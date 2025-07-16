-- src/enemy.lua

local Enemy = {}
Enemy.__index = Enemy

function Enemy:new(x, y, options)
    options = options or {}

    local obj = {
        x = x or 0,
        y = y or 0,
        speed = options.speed or 600,
        width = options.width or 32,
        height = options.height or 32,
        sprite = love.graphics.newImage(options.sprite or "assets/sprites/enemy1.png"),
        isDead = false,
        health = options.health or 1
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