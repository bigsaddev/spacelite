local StateManager = require("statemanager")
local util         = require("src.util")

local Menu = {}

function Menu:enter()
    love.math.setRandomSeed(os.time())
    GameFont = love.graphics.newFont("assets/fonts/PixelifySans-Regular.ttf", 24)
    love.graphics.setFont(GameFont)
end

function Menu:update(dt)
    -- update Menu logic
end

-- TODO: IMPLEMENT SEXY MENU
function Menu:draw()
    local menuTextWidth = GameFont:getWidth("Main Menu")
    love.graphics.print("Main Menu", util.halfWindowWidth - menuTextWidth / 2, 50)
end

function Menu:keypressed(key)
    if key == "return" then
        -- Change to game state
        StateManager:changeState("game")
    end
    if key == "escape" then
        love.event.quit()
    end
end

function Menu:exit()
    print("Exiting Menu")
end

return Menu
