local Util = {
    windowWidth = love.graphics.getWidth(),
    windowHeight = love.graphics.getHeight(),
    halfWindowWidth = love.graphics.getWidth() / 2,
    halfWindowHeight = love.graphics.getHeight() / 2
}

function Util.collidesWithRect(obj, obj2)
    return obj.x < obj2.x + obj2.width and
        obj.x + obj.width > obj2.x and
        obj.y < obj2.y + obj2.height and
        obj.y + obj.height > obj2.y
end

function Util.Clamp(val, min, max)
    return math.max(min, math.min(val, max))
end

return Util