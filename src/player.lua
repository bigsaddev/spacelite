-- src/player.lua
local Bullet = require("src.bullet")

local function Clamp(val, min, max)
    return math.max(min, math.min(val, max))
end

local Player = {}
Player.__index = Player

local player_bounds = {
    x = 0,
    y = 0,
    width = 400,
    height = love.graphics.getHeight() - 50
}

local player_hud = {
    x = 1,
    y = love.graphics.getHeight() - 50,
    width = love.graphics.getWidth() - 1,
    height = 50
}

function Player:new(x, y)
    local obj = {
        x = x or 0,
        y = y or 0,
        speed = 300,
        width = 32,
        height = 32,
        bullets = {},
        bulletSpeed = 500,
        fireCooldown = 0.2,
        timeSinceLastShot = 0,
        color = { r = 1, g = 1, b = 1 }
    }
    setmetatable(obj, self)
    return obj
end

function Player:update(dt, enemies)
    self:handleInput(dt)

    self.timeSinceLastShot = self.timeSinceLastShot + dt

    for i = #self.bullets, 1, -1 do
        local bullet = self.bullets[i]
        bullet:update(dt, enemies)
        if bullet.isDead then
            table.remove(self.bullets, i)
        end
    end
end

function Player:draw()
    self:drawHud()
    love.graphics.setColor(self.color.r, self.color.g, self.color.b)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1) -- reset color to white

    -- player bounds for debugging
    -- love.graphics.rectangle("line", player_bounds.x, player_bounds.y, player_bounds.width, player_bounds.height)

    for _, bullet in ipairs(self.bullets) do
        bullet:draw()
    end
end

function Player:handleInput(dt)
    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        self.y = self.y - self.speed * dt
    end
    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        self.y = self.y + self.speed * dt
    end
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        self.x = self.x - self.speed * dt
    end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        self.x = self.x + self.speed * dt
    end
    
    -- Clamp the player to specified area
    self.x = Clamp(self.x, player_bounds.x, player_bounds.x + player_bounds.width - self.width)
    self.y = Clamp(self.y, player_bounds.y, player_bounds.y + player_bounds.height - self.height)

    -- Shoot
    if love.keyboard.isDown("space") and self.timeSinceLastShot >= self.fireCooldown then
        self:shoot()
        self.timeSinceLastShot = 0
    end
end

function Player:drawHud()
    love.graphics.rectangle("line", player_hud.x, player_hud.y, player_hud.width, player_hud.height)
end

function Player:shoot()
    local bulletX = self.x + self.width - 8
    local bulletY = self.y + self.height / 2 - 2
    table.insert(self.bullets, Bullet:new(bulletX, bulletY, self.bulletSpeed))
end

return Player