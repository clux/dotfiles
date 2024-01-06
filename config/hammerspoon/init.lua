mash = {"⌘", "⌥", "⌃"}

local function toggleApp(name)
  local app = hs.application.find(name)
  if not app or app:isHidden() then
    hs.application.launchOrFocus(name)
  elseif hs.application.frontmostApplication() ~= app then
    app:activate()
  else
    -- NB: does not bring back fullscreen if we were fullscreen..
    -- Could maybe write a dedicated toggler that remembers fullscreen, but don't care that much.
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


hs.hotkey.bind({ "shift", "alt" }, "m", function()
  hs.execute("focus_yabai_window", true)
end)

-- window moving between monitors/spaces
for i = 1, 9 do
  local num = tostring(i)
  alt(num, { "space --focus " .. num })
  shiftAlt(num, { "window --space " .. num, "space --focus " .. num })
end
--shiftAlt("tab", { "space --focus recent" })

-- NOTE: hjkl -> neio in colemak - use as arrow keys
local homeRow = { n = "west", e = "south", i = "north", o = "east" }

for key, direction in pairs(homeRow) do
	alt(key, { "window --focus " .. direction })
	shiftAlt(key, { "window --swap " .. direction })
end

-- window resize
shiftAlt("down",  { "window --resize bottom:0:20" }) -- increase down
shiftAlt("right", { "window --resize right:20:0" }) -- increase right
shiftAlt("up",    { "window --resize bottom:0:-20" }) -- decrease down
shiftAlt("left",  { "window --resize right:-20:0" }) -- decrease right

-- mode toggles for spaces and windows
--shiftAlt("y", { "space --layout bsp" })
--shiftAlt("u", { "space --layout stack" })
--shiftAlt(";", { "space --layout float" }) --probably only want to do this for windows only?
alt("f", { "window --toggle zoom-fullscreen" })
shiftAlt("f", { "window --toggle native-fullscreen" })
alt("l", { "window --toggle float", "window --grid 8:10:1:1:8:6" }) -- unfloat/float + center
shiftAlt("l", { "window --toggle topmost", "window --grid 5:5:4:1:4:4" }) -- pin cornered on a ws

-- NB: alt-f only works on mac if you keep modifiers in the same position

-- mini pip window, note; does not retain properties correctly on yabai restart
--shiftAlt("p", { "window --toggle pip", "window --toggle float", "window --toggle sticky", "window --toggle topmost" })
--shiftAlt("v", { "space --toggle padding", "space --toggle gap" })

-- layout experiments
shiftAlt("r", { "space --rotate 90" })
