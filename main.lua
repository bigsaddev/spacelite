-- main.lua
local Game = require("states.game")
local StateManager = require("statemanager")

function love.load()
    StateManager:changeState("menu")
end
function love.update(dt)
    StateManager:update(dt)
end
function love.draw()
    StateManager:draw()
end

function love.keypressed(key)
    StateManager:keypressed(key)
end