local Bullet = {}
Bullet.__index = Bullet

function Bullet:new(x, y, speed)
    local obj = {
        x = x,
        y = y,
        width = 10,
        height = 4,
        speed = speed,
        isDead = false,
        damage = 1
    }
    setmetatable(obj, Bullet)
    return obj
end

function Bullet:update(dt, enemies)
    self.x = self.x + self.speed * dt
    if self.x > love.graphics.getWidth() then
        self.isDead = true
        return
    end

    for _, enemy in ipairs(enemies) do
        if not enemy.isDead and self:collidesWidth(enemy) then
            self.isDead = true
            enemy:takeDamage(self.damage)
            break
        end
    end
end

function Bullet:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Bullet:collidesWidth(other)
    return self.x < other.x + other.width and
        self.x + self.width > other.x and
        self.y < other.y + other.height and
        self.y + self.height > other.y
end

return Bullet