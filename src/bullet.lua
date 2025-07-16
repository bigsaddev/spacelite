local util = require("src.util")

local Bullet = {}
Bullet.__index = Bullet

function Bullet:new(x, y, speed)
    local sprite = love.graphics.newImage("assets/sprites/bullet.png")

    local obj = {
        x = x,
        y = y,
        width = 10,
        height = 10,
        speed = speed,
        isDead = false,
        sprite = sprite,
        damage = 1
    }
    setmetatable(obj, Bullet)
    return obj
end

function Bullet:update(dt, enemies)
    self.x = self.x + self.speed * dt
    if self.x > util.windowWidth then
        self.isDead = true
        return
    end

    for _, enemy in ipairs(enemies) do
        if not enemy.isDead and util.collidesWithRect(self, enemy) then
            self.isDead = true
            enemy:takeDamage(self.damage)
            break
        end
    end
end

function Bullet:draw()
    love.graphics.draw(self.sprite, self.x, self.y)
end

return Bullet