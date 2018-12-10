return function(f)
  local t = window.create(term.current(), 1, 1, term.getSize())
  local oldTerm = term.redirect(t)

  local success, message = pcall(f)

  t.setVisible(false)
  term.redirect(oldTerm)
  term.setTextColor(colors.white)
  term.setBackgroundColor(colors.black)
  term.clear()
  term.setCursorPos(1, 1)

  if not success then
    term.setTextColor(colors.orange)
    print(message)
  end
  t:redraw()
end
