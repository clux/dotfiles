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

-- Global terminal toggle
hs.hotkey.bind({}, "F1", function() toggleApp("alacritty") end)

-- Misc app shortcuts
hs.hotkey.bind(mash, "v", function() toggleApp("Visual Studio Code") end)
hs.hotkey.bind(mash, "p", function() toggleApp("System Preferences") end)
hs.hotkey.bind(mash, "s", function() toggleApp("Slack") end)
hs.hotkey.bind(mash, "d", function() toggleApp("Discord") end)

hs.hotkey.bind(mash, "r", function() hs.reload(); end)
hs.alert("HS config loaded")
