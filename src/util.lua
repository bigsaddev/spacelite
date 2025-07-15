local Util = {}

function Util.collidesWithRect(obj, obj2)
    return obj.x < obj2.x + obj2.width and
        obj.x + obj.width > obj2.x and
        obj.y < obj2.y + obj2.height and
        obj.y + obj.height > obj2.y
end

return Util