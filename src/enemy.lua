-- src/enemy.lua

local Enemy = {}
Enemy.__index = Enemy

function Enemy:new(x, y, options)
    options = options or {}

    local sprite = love.graphics.newImage(options.sprite)

    local obj = {
        x = x or 0,
        y = y or 0,
        speed = options.speed or 200,
        width = options.width or 32,
        height = options.height or 32,
        sprite = sprite,
        isDead = false,
        health = options.health or 3,
        reward = options.reward,
    }
    setmetatable(obj, self)
    return obj
end

function Enemy:update(dt)
    self.x = self.x - self.speed * dt
end

local healthSize = 5
local healthSpacing = 2

function Enemy:draw()
    if not self.isDead then
        love.graphics.draw(self.sprite, self.x, self.y)

        -- Calculate total width of all health boxes
        local totalWidth = self.health * healthSize + (self.health - 1) * healthSpacing

        -- Start X position to center health above the enemy
        local startX = self.x + (self.width / 2) - (totalWidth / 2)
        local healthY = self.y - 8

        for i = 1, self.health do
            local healthX = startX + (i - 1) * (healthSize + healthSpacing)

            -- Black border
            love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle("fill", healthX - 1, healthY - 1, healthSize + 2, healthSize + 2)

            -- White square
            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle("fill", healthX, healthY, healthSize, healthSize)
        end

        love.graphics.setColor(1, 1, 1) -- Reset color
    end
end

function Enemy:takeDamage(amount)
    self.health = self.health - amount
    if self.health <= 0 then
        self.isDead = true
    end
end

return Enemy