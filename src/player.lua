-- src/player.lua
local Bullet = require("src.bullet")
local util   = require("src.util")

local Player = {}
Player.__index = Player

local player_bounds = {
    x = 0,
    y = 0,
    width = 400,
    height = util.windowHeight - 50
}

local player_hud = {
    x = 1,
    y = util.windowHeight - 50,
    width = util.windowWidth - 1,
    height = 50
}

local glow = love.graphics.newShader("shader/glow.glsl")
function Player:new(x, y)
    local obj = {
        x = x or 0,
        y = y or 0,
        speed = 350,
        width = 32,
        height = 32,
        sprite = love.graphics.newImage("assets/sprites/player.png"),
        scale = 1,
        bullets = {},
        bulletSpeed = 500,
        fireCooldown = 0.2,
        timeSinceLastShot = 0,
        health = 3,
        money = 0,
    }

    glow:send("glowColor", {1.0, 0.5, 1.0, 1.0}) -- orange glow
    glow:send("radius", 1)
    glow:send("textureSize", {32, 32})

    setmetatable(obj, Player)
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
    love.graphics.setShader(glow)
    love.graphics.draw(self.sprite, self.x, self.y, 0, self.scale)
    love.graphics.setShader()
    -- player bounds for debugging
    -- love.graphics.rectangle("line", player_bounds.x, player_bounds.y, player_bounds.width, player_bounds.height)

    for _, bullet in ipairs(self.bullets) do
        bullet:draw()
    end

    -- Clamp the player to specified area
    self.x = util.Clamp(self.x, player_bounds.x, player_bounds.x + player_bounds.width - self.width)
    self.y = util.Clamp(self.y, player_bounds.y, player_bounds.y + player_bounds.height - self.height)
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
    
    -- Shoot
    if love.keyboard.isDown("space") and self.timeSinceLastShot >= self.fireCooldown then
        self:shoot()
        self.timeSinceLastShot = 0
    end
end

function Player:drawHud()
    love.graphics.rectangle("line", player_hud.x, player_hud.y, player_hud.width, player_hud.height)
    
    love.graphics.setColor(0, 1, 0)
    local healthWidth = GameFont:getWidth("Health: " .. self.health)
    love.graphics.print("Health: " .. self.health, player_hud.x + 10, player_hud.y + 10)
    
    love.graphics.setColor(1, 1, 0)
    love.graphics.print("Money: " .. self.money, player_hud.x + healthWidth + 30, player_hud.y + 10)
    love.graphics.setColor(1, 1, 1)
end

function Player:shoot()
    local bulletX = self.x + self.width - 5
    local bulletY = self.y + self.height / 2 - 5
    table.insert(self.bullets, Bullet:new(bulletX, bulletY, self.bulletSpeed))
end

function Player:takeDamage(amount)
    self.health = self.health - amount
end

function Player:receiveMoney(amount)
    self.money = self.money + amount
end

return Player