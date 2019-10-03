return function(t)
  return setmetatable(t, {__index = {
    render = function(self)
    end,
    update = function(self)
    end
  }})
end
