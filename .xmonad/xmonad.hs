import Graphics.X11.ExtraTypes.XF86
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Util.AudioKeys
import XMonad.Util.EZConfig

main = xmonad =<< statusBar "xmobar" bwBarPP toggleStrutsKey (withUrgencyHook NoUrgencyHook
  def {
    -- Change the default terminal for: window resizing, clickable
    -- URLs, and urgent hints.
      terminal   = "terminator"

    -- [1..4] : work items, increasing importance from right to left  (L<-R)
    -- "-"    : long-running rarely-checked windows
    -- [6..9] : other items, increasing importance from left to right (L->R)
    , workspaces = map show [1..4] ++ ("-" : map show [6..9])

    , layoutHook = myLayout
  } `additionalKeys` [
      ((mod4Mask, xK_l                    ), spawn "i3lock")

    -- Audio
    , ((0,        xF86XK_AudioRaiseVolume ), spawn $ setVolFeedback "+5%")
    , ((0,        xF86XK_AudioLowerVolume ), spawn $ setVolFeedback "-5%")
    , ((0,        xF86XK_AudioMute        ), spawn $ setMute True)

    -- Appearance
    , ((0,        xF86XK_MonBrightnessUp  ), spawn "xbacklight +5%")
    , ((0,        xF86XK_MonBrightnessDown), spawn "xbacklight -5%")
    , ((mod4Mask, xK_i                    ), spawn "xrandr-invert-colors")
    , ((mod4Mask, xK_r                    ), spawn "redshift -O 3500")
    , ((mod4Mask, xK_b                    ), spawn "redshift -O 5500")
  ])

-- A simple black and white color scheme for log info
bwBarPP = def {ppUrgent  = xmobarColor "white" "black" . pad}

-- Add the shift mask to the default keybinding to avoid a conflict with our terminal
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask .|. shiftMask, xK_b)

myLayout = tiled ||| Mirror split ||| Full
  where
     -- Tall nmaster delta mratio
     split = Tall 2 (3/100) (9/10)
     tiled = Tall 1 (3/100) (1/2)
