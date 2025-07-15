-- src/game.lua

local Player = require("src.player")
local WaveManager = require("src.wavemanager")

local Game = {}

function Game:load()
    love.math.setRandomSeed(os.time())
    GameFont = love.graphics.newFont("assets/fonts/PixelifySans-Regular.ttf", 24)
    love.graphics.setFont(GameFont)
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
    -- Debug purpose
    love.graphics.print("Wave Paused? " .. tostring(self.wm.wavePaused), 5, 20)
    
    -- Clean this up somewhere else
    if self.wm.wavePaused then
        local readyLength = GameFont:getWidth("Ready? Press [R] to start")
        love.graphics.print("Ready? Press [R] to start!", love.graphics.getWidth()/2-readyLength/2, 10)
    end

    if not self.wm.wavePaused then
        local waveTimerLength = GameFont:getWidth("Next Wave in: " .. math.floor(self.wm.waveTimer))
        love.graphics.print("Next Wave in: " .. math.floor(self.wm.waveTimer), love.graphics.getWidth()/2-waveTimerLength/2, 40)
    end
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