local util = require("src.util")

local Bullet = {}
Bullet.__index = Bullet

function Bullet:new(x, y, speed)
    local obj = {
        x = x,
        y = y,
        width = 10,
        height = 10,
        speed = speed,
        isDead = false,
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
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1)
end

return Bullet