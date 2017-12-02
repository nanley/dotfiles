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
    -- Change the default terminal for: window resizing, clickable
    -- URLs, and urgent hints.
      terminal   = "terminator"

    -- Visually differentiate the middle workspace.
    , workspaces = map show [1..4] ++ ("-" : map show [6..9])
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
    , ((mod4Mask, xK_Page_Up  ), spawn "xbacklight +5%")   -- brighten
    , ((mod4Mask, xK_Page_Down), spawn "xbacklight -5%")   -- darken
    , ((mod4Mask, xK_End      ), spawn $ redshift "peek")  -- peek at the natural color
    , ((mod4Mask, xK_t        ), withFocused toggleBorder) -- toggle border
  ]

-- Redshift utility commands
redshift "peek" = redshift "stop" ++ "; sleep 30 ; " ++ redshift "start"
redshift cmd    = "systemctl --user " ++ cmd ++" redshift"
