import XMonad
import XMonad.Actions.NoBorders
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Util.AudioKeys
import XMonad.Util.EZConfig

main = xmonad =<< statusBar "xmobar" bwBarPP toggleStrutsKey
 (withUrgencyHook NoUrgencyHook myConfig)

-- A simple black and white color scheme for log info
bwBarPP = def {ppUrgent  = xmobarColor "white" "black" . pad}

-- Add the shift mask to the default keybinding to avoid a conflict with our terminal
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask .|. shiftMask, xK_b)

myConfig = def {
    -- Use a terminal which supports window-resizing.
      terminal = "alacritty",

    -- Visually differentiate the middle workspace.
      workspaces = map show [1..4] ++ ("✞✞✞" : map show [6..9])
  } `additionalKeys` myKeys

myKeys = [
    -- Security
      ((mod4Mask, xK_l    ), spawn "i3lock")

    -- Audio
    , ((mod4Mask, xK_Up   ), spawn $ setVolFeedback "+5%")
    , ((mod4Mask, xK_Down ), spawn $ setVolFeedback "-5%")
    , ((mod4Mask, xK_Right), spawn $ setVolFeedback "+0%")
    , ((mod4Mask, xK_Left ), spawn $ setMute True)

    -- Appearance
    , ((mod4Mask, xK_Page_Up  ), spawn "xbacklight -inc 5")   -- brighten
    , ((mod4Mask, xK_Page_Down), spawn "xbacklight -dec 5")   -- darken
    , ((mod4Mask, xK_Home     ), spawn "xrandr-invert-colors")  -- invert (when Redshift is paused)
    , ((mod4Mask, xK_End      ), spawn "pkill -USR1 redshift")  -- toggle Redshift
    , ((mod4Mask, xK_t        ), withFocused toggleBorder) -- toggle border
  ]
