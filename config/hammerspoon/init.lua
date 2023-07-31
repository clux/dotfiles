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

hs.hotkey.bind(mash, "r", function() hs.reload(); os.execute("/opt/homebrew/bin/yabai --restart-service"); end)
hs.alert("HS + yabai loaded")

--function bindCmd(key, cmd)
--  hs.hotkey.bind({"shift", "alt"}, key, function() os.execute(cmd) end)
--end


-- Yabai
local function yabai(commands)
  for _, cmd in ipairs(commands) do
    os.execute("/opt/homebrew/bin/yabai -m " .. cmd)
  end
end
-- bind on alt/shift only (modifier switch + ctrl intercepted elsewhere in e.g. alacritty)
local function alt(key, commands)
  hs.hotkey.bind({ "alt" }, key, function()
    yabai(commands)
  end)
end
local function shiftAlt(key, commands)
  hs.hotkey.bind({ "shift", "alt" }, key, function()
    yabai(commands)
  end)
end


-- window moving between monitors/spaces
for i = 1, 4 do
  local num = tostring(i)
  alt(num, { "space --focus " .. num })
  shiftAlt(num, { "window --space " .. num, "space --focus " .. num })
end
--shiftAlt("tab", { "space --focus recent" })

-- NOTE: use as arrow keys
local homeRow = { h = "west", n = "south", e = "north", i = "east" }

for key, direction in pairs(homeRow) do
	--alt(key, { "window --focus " .. direction })
  -- TODO: need a good modifier not eaten by chrome for focus without shift
	shiftAlt(key, { "window --swap " .. direction })
end


-- window resize
shiftAlt("down",  { "window --resize bottom:0:20" }) -- increase down
shiftAlt("right", { "window --resize right:20:0" }) -- increase right
shiftAlt("up",    { "window --resize bottom:0:-20" }) -- decrease down
shiftAlt("left",  { "window --resize right:-20:0" }) -- decrease right

-- mode toggles for spaces and windows
shiftAlt("y", { "space --layout bsp" })
shiftAlt("u", { "space --layout float" }) --probably only want to do this for windows only?
shiftAlt("f", { "window --toggle native-fullscreen" })
--shiftAlt("f", { "window --toggle zoom-fullscreen" })
-- TODO: find a modifier that works so we can use shift for the "stronger fullscreen"

shiftAlt("p", { "window --toggle pip" })
--shiftAlt("v", { "space --toggle padding", "space --toggle gap" })

-- layout experiments
-- NB: toggling float is a bit awkward because it keeps the window size pinned after making you rename
shiftAlt("l", { "window --toggle float" })
--shiftalt("b", { "window --grid 5:5:1:1:3:3" }) -- center
-- TODO: find a sensible way to toggle float that pops into centered window IF we are turning it on?

shiftAlt("r", { "space --rotate 90" })

-- TODO: global configs to set: mouse_follow_focus, mouse_modifier to super? and mouse_action1 == move, mouse_action2 == resize
