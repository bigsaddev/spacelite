local StateManager = {}

local currentState = nil
local states = {}

function StateManager:changeState(stateName)
    -- Load state module if not loaded yet
    if not states[stateName] then
        local ok, state = pcall(require, "states." .. stateName)
        if ok then
            states[stateName] = state
        else
            error("Failed to load state '" .. stateName .. "': " .. tostring(state))
        end
    end

    -- Exit current state if applicable
    if currentState and currentState.exit then
        currentState:exit()
    end

    currentState = states[stateName]

    -- Enter new state if it has an enter function
    if currentState.enter then
        currentState:enter()
    end
end

function StateManager:update(dt)
    if currentState and currentState.update then
        currentState:update(dt)
    end
end

function StateManager:draw()
    if currentState and currentState.draw then
        currentState:draw()
    end
end

function StateManager:keypressed(key)
    if currentState and currentState.keypressed then
        currentState:keypressed(key)
    end
end

return StateManager
