-- src/wavemanager.lua
local Enemy = require("src.enemy")

local WaveManager = {}
WaveManager.__index = WaveManager

function WaveManager:new()
    local obj = {
        waveTimer = 10,
        currentWave = 0,
        enemies = {}, -- DO NOT FORGET THIS, THIS BISH BE MANAGING YOUR ENEMIES
        wavePaused = true
    }
    setmetatable(obj, self)
    return obj
end

function WaveManager:spawnWave(count)
    for i = 1, count do
        local x = love.math.random(love.graphics.getWidth(), love.graphics.getWidth() + 500)
        local y = love.math.random(0, love.graphics.getHeight() - 100)
        table.insert(self.enemies, Enemy:new(x, y))
        print(x .. y)
    end
    self.currentWave = self.currentWave + 1
end

function WaveManager:updateWave(dt)
    for i = #self.enemies, 1, -1 do
        local enemy = self.enemies[i]
        enemy:update(dt)

        -- Remove enemies off screen
        if enemy.x + enemy.width < 0 then
            table.remove(self.enemies, i)
        end
    end


    -- decrease timer, counting up was weird
    if not self.wavePaused and #self.enemies == 0 then
        self.waveTimer = self.waveTimer - dt
        if self.waveTimer <= 0 then
            self.waveTimer = 10
            self:spawnWave(3 + self.currentWave) -- increase count each wave
        end
    end

    -- delete dead enemies from the table
    for i = #self.enemies, 1, -1 do
        if self.enemies[i].isDead then
            table.remove(self.enemies, i)
        end
    end
end

function WaveManager:drawWave()
    for _, enemy in ipairs(self.enemies) do
        enemy:draw()
    end

    love.graphics.print("Wave: " .. self.currentWave, 5, 0)
end

function WaveManager:startWaves()
    self.wavePaused = false
    self.waveTimer = 10
end

function WaveManager:stopWaves()
    self.wavePaused = true
    self.waveTimer = 10
end

function WaveManager:getEnemies()
    return self.enemies
end

return WaveManager