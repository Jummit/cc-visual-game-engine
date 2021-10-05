return function(base)
    setmetatable(base, {__index = {
        x = 1, y = 1, w = 1, h = 1, visible = true,
        draw = function()
        end,
        update = function()
        end,
        init = function()
        end,
    }})
    return function(t)
        return setmetatable(t, {__index = base})
    end
end