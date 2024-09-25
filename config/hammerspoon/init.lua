mash = {"⌘", "⌥", "⌃"}

-- Non-laggy exec
function aerospace(args)
  hs.task.new("/opt/homebrew/bin/aerospace", function(ud, ...)
    hs.inspect(table.pack(...))
    return true
  end, args):start()
end

MAIN="3"
local function activateApp(name)
  local app = hs.application.find(name)
  if not app or app:isHidden() then
    hs.application.launchOrFocus(name)
  elseif hs.application.frontmostApplication() ~= app then
    app:activate()
  else
    -- unfortunately we cannot swap back easily with aerospace
    -- hiding the window would mean an empty workspace or pulling in another window
    -- thus we hardcode the toggle return
    aerospace({"workspace", MAIN})
  end
end

-- Global terminal activation
hs.hotkey.bind({}, "F1", function() activateApp("alacritty") end)
hs.hotkey.bind(mash, "r", function() hs.reload(); aerospace("reload-config"); end)
hs.alert("HS + aerospace loaded")

-- TODO: use hs to trigger aerospace for switching so we could keep track of MAIN?
