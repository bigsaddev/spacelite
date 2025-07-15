-- src/game.lua

local Player = require("src.player")
local WaveManager = require("src.wavemanager")

local Game = {}

function Game:load()
    love.math.setRandomSeed(os.time())
    self.player = Player:new(100, 100)
    self.wm = WaveManager:new()
end

function Game:update(dt)
    self.player:update(dt, self.wm.enemies)
    self.wm:updateWave(dt)
end

function Game:draw()
    self.player:draw()
    self.wm:drawWave()
    love.graphics.print("Press Enter to start spawning Waves")
end

function Game:keypressed(key)
    if key == "return" then -- press Enter to start waves
        self.wm:startWaves()
    end
    if key == "escape" then
        love.event.quit()
    end
 end

return Game