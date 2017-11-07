import Graphics.X11.ExtraTypes.XF86
import XMonad
import XMonad.Util.AudioKeys
import XMonad.Util.EZConfig

main = xmonad
  (def {
    -- Change the default terminal for: window resizing, clickable
    -- URLs, and urgent hints.
      terminal   = "terminator"
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

myLayout = tiled ||| Mirror split ||| Full
  where
     -- Tall nmaster delta mratio
     split = Tall 2 (3/100) (9/10)
     tiled = Tall 1 (3/100) (1/2)
