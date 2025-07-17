-- src/game.lua

local Player = require("src.player")
local WaveManager = require("src.wavemanager")

local Game = {}

function Game:load()
    self.player = Player:new(100, 100)
    self.wm = WaveManager:new()
end

function Game:enter()
    print("boop")
    self:load() -- probably load stuff earlier than this
end

function Game:update(dt)
    self.player:update(dt, self.wm.enemies)
    self.wm:updateWave(dt, self.player)
end

function Game:draw()
    love.graphics.setBackgroundColor(0, 0, 0)
    self.player:draw()

    -- Draws the enemies in waves
    self.wm:drawWave()
    
    -- Draws the wave information
    self.wm:drawHud()
    
    -- Debug purpose
    --love.graphics.print("Wave Paused? " .. tostring(self.wm.wavePaused), 5, 20)
end

function Game:keypressed(key)
    if key == "r" then -- press r to start waves
        self.wm:startWaves()
    end
    if key == "escape" then -- quit game
        love.event.quit()
    end
 end

return Game