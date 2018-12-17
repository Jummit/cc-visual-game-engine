return {
  update = function(self, event, var1, var2, var3)
    if event == "key" then
      self[keys.getName(var1)] = true
    elseif event == "key_up" then
      self[keys.getName(var1)] = false
    end
  end
}
