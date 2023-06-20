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

-- Yabai
function bindCmd(key, cmd)
  -- NB: need a modifier that is not ctrl or cmd because modifier switch + ctrl intercepted by alacritty
  hs.hotkey.bind({"shift", "alt"}, key, function() os.execute(cmd) end)
end

bindCmd("1", "/opt/homebrew/bin/yabai -m window --space 1; /opt/homebrew/bin/yabai -m display --focus 1")
bindCmd("2", "/opt/homebrew/bin/yabai -m window --space 2; /opt/homebrew/bin/yabai -m display --focus 2")
