-- src/wavemanager.lua
local Enemy = require("src.enemy")
local util  = require("src.util")

local WaveManager = {}
WaveManager.__index = WaveManager

function WaveManager:new()
    local obj = {
        waveTimer = 3, -- TODO: change back to something better
        currentWave = 0,
        enemies = {}, -- DO NOT FORGET THIS, THIS BISH BE MANAGING YOUR ENEMIES
        wavePaused = true
    }
    setmetatable(obj, self)
    return obj
end

function WaveManager:spawnWave(count)
    for i = 1, count do
        local x = love.math.random(util.windowWidth, util.windowWidth + 500)
        local y = love.math.random(0, util.windowHeight - 100)
        table.insert(self.enemies, Enemy:new(x, y))
    end
    self.currentWave = self.currentWave + 1
end

function WaveManager:updateWave(dt)
    for i = #self.enemies, 1, -1 do
        local enemy = self.enemies[i]
        enemy:update(dt)

        -- Remove off screen enemies
        if enemy.x + enemy.width < 0 then
            table.remove(self.enemies, i)
        end

        -- Remove dead enemies
        if self.enemies[i].isDead then
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
end

function WaveManager:drawWave()
    for _, enemy in ipairs(self.enemies) do
        enemy:draw()
    end

    love.graphics.print("Wave: " .. self.currentWave, 5, 0)
end

function WaveManager:startWaves()
    self.wavePaused = false
    self.waveTimer = self.waveTimer
end

function WaveManager:stopWaves()
    self.wavePaused = true
    self.waveTimer = self.waveTimer
end

function WaveManager:getEnemies()
    return self.enemies
end

function WaveManager:drawHud()
    if self.wavePaused then
        local readyLength = GameFont:getWidth("Ready? Press [R] to start")
        love.graphics.print("Ready? Press [R] to start!", util.halfWindowWidthwindowWidth - readyLength / 2, 10)
    end

    if not self.wavePaused then
        local waveTimerLength = GameFont:getWidth("Next Wave in: " .. math.floor(self.waveTimer))
        love.graphics.print("Next Wave in: " .. math.floor(self.waveTimer), util.halfWindowWidthwindowWidth - waveTimerLength / 2, 40)
    end
end

return WaveManager