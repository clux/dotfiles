mash = {"⌘", "⌥", "⌃"}

local function toggleApp(name)
  local app = hs.application.find(name)
  if not app or app:isHidden() then
    hs.application.launchOrFocus(name)
  elseif hs.application.frontmostApplication() ~= app then
    app:activate()
  else
    app:hide()
  end
end

hs.hotkey.bind(mash, "b", function() toggleApp("Visual Studio Code") end)
hs.hotkey.bind(mash, "f", function() toggleApp("Finder") end)
hs.hotkey.bind(mash, "p", function() toggleApp("System Preferences") end)
hs.hotkey.bind(mash, "t", function() toggleApp("Slack") end)
hs.hotkey.bind(mash, "l", function() toggleApp("alacritty") end)

hs.hotkey.bind(mash, "r", function() hs.reload(); end)
hs.alert("HS config loaded")
