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

-- window moving between monitors
bindCmd("1", "/opt/homebrew/bin/yabai -m window --space 1; /opt/homebrew/bin/yabai -m display --focus 1")
bindCmd("2", "/opt/homebrew/bin/yabai -m window --space 2; /opt/homebrew/bin/yabai -m display --focus 2")
bindCmd("3", "/opt/homebrew/bin/yabai -m window --space 3; /opt/homebrew/bin/yabai -m display --focus 3")

-- window resize
bindCmd("down", "/opt/homebrew/bin/yabai -m window --resize bottom:0:20") -- increase down
bindCmd("right",  "/opt/homebrew/bin/yabai -m window --resize right:20:0") -- increase right
bindCmd("up",    "/opt/homebrew/bin/yabai -m window --resize bottom:0:-20") -- decrease down
bindCmd("left",  "/opt/homebrew/bin/yabai -m window --resize right:-20:0") -- decrease right

-- set a thing to be sticky (excludes it from bsp tiling)
bindCmd("4", "/opt/homebrew/bin/yabai -m window --toggle sticky; /opt/homebrew/bin/yabai -m window --toggle topmost")
bindCmd("y", "/opt/homebrew/bin/yabai -m space --layout bsp")
bindCmd("u", "/opt/homebrew/bin/yabai -m space --layout float")
