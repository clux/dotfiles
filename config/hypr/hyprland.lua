
require("mocha")

-- ---------------------------------------------------------
-- MONITOR
-- ---------------------------------------------------------
-- https://wiki.hyprland.org/Configuring/Monitors/

-- Main Monitor M28U on HDMI.
-- NB: scaling broken on chrome - have reverted to factor=1
-- https://www.reddit.com/r/kde/comments/136wxuk/chrome_version_113_scaling_issue_under_wayland/
-- This is fine provided everything else is scaled up, and that's actually less limiting.
-- Only downside is the chrome tabs are tiny compared to everything else.
hl.monitor({
    output = "HDMI-A-2",
    mode = "3840x2160@120",
    position = "0x0",
    scale = "1",
})

-- ---------------------------------------------------------
-- CONFIG
-- ---------------------------------------------------------

-- Input https://wiki.hyprland.org/Configuring/Variables/
hl.config({
    input = {
        kb_layout = "us,us",
        kb_variant = "colemak,altgr-intl",
        kb_model = "",
        kb_options = "caps:hyper",
        -- NB: grp:alt_shift_toggle replaced below
        kb_rules = "",
        follow_mouse = 1,
        --force_no_accel = 1
        accel_profile = "flat",
        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
    },
    -- grp:alt_shift_toggle replacement that also pings waybar to force module redraw
    general = {
        -- defaults; https://wiki.hyprland.org/Configuring/Variables/
        gaps_in = 6,
        gaps_out = 3,
        border_size = 2,
        --col.active_border = $mauve $pink 45deg
        --col.inactive_border = $surface1
        --col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
        --col.inactive_border = rgba(595959aa)
        col = {
            active_border = { colors = { "rgb(24273A)", "rgb(24273A)", "rgb(24273A)", "rgb(24273A)" } },
            inactive_border = { colors = { "rgb(24273A)", "rgb(24273A)", "rgb(24273A)", "rgb(24273A)" } },
        },
        layout = "dwindle",
    },
    decoration = {
        -- https://wiki.hypr.land/configuring/core/config-options/#decoration
        rounding = 0,
        blur = {
            enabled = true,
            size = 2,
            passes = 2,
            new_optimizations = true,
            ignore_opacity = true,
        },
        shadow = {
            enabled = true,
            range = 10,
            render_power = 3,
            --color = rgba(1a1a1aee)
            color = lavender,
        },
        -- don't dim modal terminal
        dim_special = 0,
    },
    animations = {
        enabled = true,
    },
    dwindle = {
        -- https://wiki.hypr.land/configuring/layouts/dwindle-layout/
        -- pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true, -- you probably want this
    },
    misc = {
        -- enable adaptive sync
        vrr = 1,
        -- fix the laggy window drag mvmnt: https://github.com/hyprwm/Hyprland/issues/1753
        --animate_mouse_windowdragging = false
        -- remove hyprland logo+rendering as it sometimes flicker in during resizes/animations
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        -- avoid awkward boot shuffle
        focus_on_activate = false,
    },
    ecosystem = {
        -- https://wiki.hypr.land/configuring/core/config-options/#ecosystem
        no_update_news = true,
        no_donation_nag = true
    },
})


-- faster curve i used to use
--bezier = slightovershoot, 0.05, 0.2, 0.1, 1.05
hl.curve("md3_standard", { type = "bezier", points = { { 0.2, 0 }, { 0, 1 } } })
hl.curve("md3_decel", { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } })
hl.curve("md3_accel", { type = "bezier", points = { { 0.3, 0 }, { 0.8, 0.15 } } })
hl.curve("overshot", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.1 } } })
hl.curve("crazyshot", { type = "bezier", points = { { 0.1, 1.5 }, { 0.76, 0.92 } } })
hl.curve("hyprnostretch", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.0 } } })
hl.curve("fluent_decel", { type = "bezier", points = { { 0.1, 1 }, { 0, 1 } } })
-- Animation configs
-- animation = border, 1, 10, default
hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 2,
    bezier = "md3_decel",
    style = "slide",
})
hl.animation({
    leaf = "fade",
    enabled = true,
    speed = 2,
    bezier = "default",
})
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 3,
    bezier = "md3_decel",
})
hl.animation({
    leaf = "specialWorkspace",
    enabled = true,
    speed = 3,
    bezier = "md3_decel",
    style = "slidevert",
})

-- ---------------------------------------------------------
-- RULES
-- ---------------------------------------------------------

-- https://wiki.hypr.land/configuring/core/rules/window-rules/
-- https://wiki.hypr.land/configuring/core/rules/layer-rules/
-- https://wiki.hypr.land/configuring/core/rules/workspace-rules/

hl.window_rule({
    name = "floating-windows",
    match = {
        class = "^(pavucontrol|mpv|feh|nwg-look|anki)$",
    },
    float = true,
})

hl.window_rule({
    name = "anki-float-layout",
    match = {
        class = "^(anki)$",
    },
    move = "(4) (1107)",
    size = "1936 1049",
})

hl.window_rule({
    name = "waybar-float-nmtui",
    match = {
        title = "^(nmtui)$",
    },
    float = true,
})

hl.window_rule({
    name = "waybar-fullscreen-btop",
    match = {
        title = "^(btop)$",
    },
    fullscreen = true,
})

hl.window_rule({
    name = "sensors-float-popup",
    match = {
        title = "^(sensors)$",
    },
    float = true,
    move = "(50) (250)",
    size = "1200 1700",
})

hl.window_rule({
    name = "wofi-modal-dim",
    match = {
        class = "^(wofi)$",
    },
    dim_around = true,
})


hl.layer_rule({
    name = "blur-wofi",
    match = {
        namespace = "wofi",
    },
    blur = true,
})

hl.layer_rule({
    name = "blur-logout",
    match = {
        namespace = "lockscreen",
    },
    ignore_alpha = 0.5,
    no_anim = true,
    -- blur = on
})


hl.window_rule({
    -- "privacy-tabs",
    match = {
        class = "^(chrome|firefox)$",
        title = "^(.*Inbox.*|.*Calendar.*|.*Bank.*)$",
    },
    no_screen_share = true,
})

hl.window_rule({
    -- "socials-on-ws-3",
    -- start social apps; Discord/WebCord + Signal on WS3
    match = {
        title = "^(.*(Disc|WebC)ord.*|Signal)$",
    },
    workspace = "3",
    no_screen_share = true,
})

hl.window_rule({
    -- "steam-on-ws-4",
    -- Start steam on WS4
    match = {
        title = "^(.*Steam*)$",
    },
    workspace = "4",
})

hl.window_rule({
    -- shunt sharing indicators from google meet + signal to a far away land
    name = "annoying-sharing-indicators",
    match = {
        title = "^(Sharing screen|Firefox.*Sharing Indicator|.*is sharing (your screen|a window)\\.)$",
    },
    workspace = "8 silent",
})

hl.window_rule({
    name = "terminal-drop-down-style",
    -- negligible visibility changes for tiny smoothness tweaks
    match = {
        class = "^Alacritty$",
    },
    no_blur = true,
    no_anim = true,
    no_shadow = true,
    no_initial_focus = true,
    border_color = "rgba(a6e3a1ee)",
})

-- remove gaps when only one window on most workspaces
hl.workspace_rule({
    workspace = "w[tv1]",
    gaps_out = 0,
    gaps_in = 0,
})

hl.workspace_rule({
    workspace = "f[1]",
    gaps_out = 0,
    gaps_in = 0,
})

hl.window_rule({
    name = "nogaps-single-window-term",
    match = {
        float = 0,
        workspace = "w[t1]",
    },
    border_size = 0,
    rounding = 0,
})

-- old unmigrated;
-- idle inhibit while watching videos
-- currently off; not using swayidle
-- windowrule {
--   name = inhibit-idlefocus
--   idle_inhibit = focus
--   match:class = ^(mpv|.+exe)$
-- }
-- windowrule {
--   name = inhibit-idle-youtube
--   idle_inhibit = focus
--   match:class = ^(chrome|firefox)$
--   match:title = ^(.*YouTube.*)$
-- }
-- windowrule {
--   name = inhibit-idlefocus-browser-fs
--   idle_inhibit = fullscreen
--   match:class = ^(chrome|firefox)$
-- }
-- ---------------------------------------------------------
-- BINDS
-- ---------------------------------------------------------

hl.bind("ALT + SHIFT_L", hl.dsp.exec_cmd("hyprctl switchxkblayout fnatic-gear-fnatic-gear-ministreak-keyboard next"))
hl.bind("ALT + SHIFT_L", hl.dsp.exec_cmd("sleep 0.1 && pkill -RTMIN+4 waybar"))

-- ALT as mainmod would be nice to align yabai + hyprland, but this ends ups triggering lang change, how does mac avoid this?
local mainMod = "SUPER"

-- guake style modal terminal via special workspace
hl.bind("F1", hl.dsp.workspace.toggle_special(""))
hl.bind("SHIFT + F2", hl.dsp.exec_cmd("[workspace special] alacritty"))
-- NB: special workspace does not allow fullscreening so it's not perfect yet.

-- restart hack that tends to fix most pipewire problems
-- also fixes screensharing in firefox (but not chrome/chromium)
hl.bind("SHIFT + F4", hl.dsp.exec_cmd("systemctl --user restart pipewire xdg-desktop-portal-hyprland xdg-desktop-portal"))

-- recording mode
hl.bind("SHIFT + F6", hl.dsp.exec_cmd("killall hyprpaper mpvpaper"))
hl.bind("SHIFT + F6", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind("SHIFT + F6", hl.dsp.exec_cmd("mpvpaper -so \"no-audio loop\" '*' ~/Downloads/moewalls4k/sunset-magical-castle-moewalls.com.mp4"))
hl.bind("SHIFT + F6", hl.dsp.exec_cmd("dunstctl set-paused false"))
hl.bind("SHIFT + F6", hl.dsp.exec_cmd("pkill -RTMIN+5 waybar"))
-- regular mode
hl.bind("SHIFT + F7", hl.dsp.exec_cmd("killall hyprpaper mpvpaper"))
hl.bind("SHIFT + F7", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind("SHIFT + F7", hl.dsp.exec_cmd("hyprpaper"))
hl.bind("SHIFT + F7", hl.dsp.exec_cmd("dunstctl set-paused false"))
hl.bind("SHIFT + F7", hl.dsp.exec_cmd("pkill -RTMIN+5 waybar"))
hl.bind("SHIFT + F7", hl.dsp.exec_cmd("sudo systemctl start docker"))
-- game mode
hl.bind("SHIFT + F8", hl.dsp.exec_cmd("killall mpvpaper hyprpaper"))
hl.bind("SHIFT + F8", hl.dsp.exec_cmd("sudo systemctl stop docker"))
hl.bind("SHIFT + F8", hl.dsp.exec_cmd("hyprctl --batch \"keyword animations:enabled 0; keyword decoration:drop_shadow 0; keyword decoration:blur 0; keyword general:gaps_in 0; keyword general:gaps_out 0; keyword general:border_size 1; keyword decoration:rounding 0\""))
hl.bind("SHIFT + F8", hl.dsp.exec_cmd("dunstctl set-paused true"))
hl.bind("SHIFT + F8", hl.dsp.exec_cmd("pkill -RTMIN+5 waybar"))

-- screenshotting (everything, selected with shift, active with ctrl)


local grimDate = "$(date +%Y-%m-%d-%H_%M_%S).png"
hl.bind("Print", hl.dsp.exec_cmd("grim ~/Pictures/grim-" .. grimDate))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("grim -g \"$(slurp)\" ~/Pictures/grim-area-" .. grimDate))
hl.bind("CONTROL + Print", hl.dsp.exec_cmd("grim -g \"$(hyprctl activewindow -j | jq -r '\"\\(.at[0]),\\(.at[1]) \\(.size[0])x\\(.size[1])\"')\" ~/Pictures/grim-active-" .. grimDate))

-- record
-- hl.bind("SHIFT + Scroll", hl.dsp.pass({ window = "^(com\\.obsproject\\.Studio)$" }))

-- media control
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"))
-- NB: XF86AudioMicMute doesnt work, seen as shift :/ command works so leaving in here
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))

-- notifications
hl.bind("SUPER + PAUSE", hl.dsp.exec_cmd("dunstctl close"))
hl.bind("SHIFT + PAUSE", hl.dsp.exec_cmd("killall -SIGUSR1 waybar"))

-- Keyboard quick resize
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x = 20, y = 0, relative = true }))
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.resize({ x = -20, y = 0, relative = true }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.resize({ x = 0, y = -20, relative = true }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.resize({ x = 0, y = 20, relative = true }))

-- obs (use shift-pause to hide waybar)
hl.bind("SUPER + SHIFT + F9", hl.dsp.pass({ window = "class:^(com\\.obsproject\\.Studio)$" }))
hl.bind("SUPER + SHIFT + F10", hl.dsp.pass({ window = "class:^(com\\.obsproject\\.Studio)$" }))

-- youtube pip
hl.bind(mainMod .. " + F11", hl.dsp.window.fullscreen_state({ internal = 0, client = 3, action = "toggle" }))

-- https://wiki.hyprland.org/Configuring/Binds/
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("wofi"))

hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("swaylock"))

hl.bind(mainMod .. " + Q", hl.dsp.window.close())

hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
-- bind = $mainMod, J, togglesplit, # dwindle

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))

-- Move active window to a workspace with mainMod + SHIFT + [0-9]
hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- switch windows within workspace (NB: this is shift-alt-r on mac..)
hl.bind(mainMod .. " + TAB", hl.dsp.window.swap({ next = true }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize())

-- ---------------------------------------------------------
-- EXEC
-- ---------------------------------------------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("wl-clipboard-history -t")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper")
    -- force cursors for all apps
    hl.exec_cmd("hyprctl setcursor 'catppuccin-mocha-sapphire-cursors' 48")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme catppuccin-mocha-sapphire-cursors")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size 48")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("alacritty", { workspace = "special" })
    hl.exec_cmd("firefox", { workspace = "1" })
    --hl.exec_cmd("google-chrome-stable --proxy-pac-url=\"data:application/x-javascript-config;base64,$(base64 -w0 $HOME/.ssh/proxy.pac)\"", { workspace = "1" })
    hl.exec_cmd("GDK_SCALE=2 discord", { workspace = "3" })
    hl.exec_cmd("ANKI_WEBSCALE=2 anki", { workspace = "5" })
    -- TODO: find a gammastep replacement / debug crashes
    --hl.exec_cmd("gammastep -m wayland -l manual -l 51:0")
end)

