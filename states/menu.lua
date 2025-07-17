local StateManager = require("statemanager")

local Menu = {}

function Menu:enter()
    print("Entered Menu")
end

function Menu:update(dt)
    -- update Menu logic
end

function Menu:draw()
    love.graphics.print("Main Menu", 400, 300)
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
