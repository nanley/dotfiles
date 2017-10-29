import XMonad
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Util.EZConfig
import Graphics.X11.ExtraTypes.XF86
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import Data.List

-- Start xmonad with xmobar and customizations.
main = xmonad =<< statusBar "xmobar" bwBarPP toggleStrutsKey (withUrgencyHook NoUrgencyHook
  $ def {
    -- [1..4] : work items, increasing importance from right to left  (L<-R)
    -- "-"    : long-running rarely-checked windows
    -- [6..9] : other items, increasing importance from left to right (L->R)
      workspaces         = map show [1..4] ++ ("-" : map show [6..9])

    -- Change the default terminal for: window resizing, clickable
    -- URLs, and urgent hints.
    , terminal           = "terminator"

    -- Workaround a bug with shellPrompt. When opening some applications
    -- (like gnome-dictionary) and the mouse is on any window,
    -- the window opens above the mouse's window and not the currently focused one.
    , focusFollowsMouse  = False
  } `additionalKeys` [
      ((mod1Mask,        xK_p                    ), shellPrompt bwPrompt)

    -- Fancy Keys
    , ((0,               xF86XK_AudioRaiseVolume ), spawn $ setVolFeedback "+5%")
    , ((0,               xF86XK_AudioLowerVolume ), spawn $ setVolFeedback "-5%")
    , ((0,               xF86XK_AudioMute        ), spawn $ setMute True)
    , ((0,               xF86XK_MonBrightnessUp  ), spawn "xbacklight +5%")
    , ((0,               xF86XK_MonBrightnessDown), spawn "xbacklight -5%")

    , ((mod4Mask,        xK_l                    ), spawn "i3lock")

    -- Appearance
    , ((mod4Mask,        xK_i                    ), spawn "xrandr-invert-colors")
    , ((mod4Mask,        xK_r                    ), spawn "redshift -O 3500")
    , ((mod4Mask,        xK_b                    ), spawn "redshift -O 5500")
  ])

-- A simple black and white color scheme for log info
bwBarPP = def {ppUrgent  = xmobarColor "white" "black" . pad}

-- Add the shift mask to the default keybinding to avoid a conflict with our terminal
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask .|. shiftMask, xK_b)

-- A prompt that takes command options
bwPrompt = def {  font ="xft:Mono:size=10"
                  , fgColor = "black"
                  , bgColor = "white"
                  , borderColor = "red"
                  , position = Top
                  , alwaysHighlight = True
                  , height = 20
                 }

setVolUnmute :: String -> String
setVolUnmute x = mergeCmd [setMute False, setVol x]

setVolFeedback :: String -> String
setVolFeedback x = mergeCmd [setVolUnmute x, playVolTest]

mergeCmd :: [String] -> String
mergeCmd x = unwords $ intersperse ";" x

-- Accepts a positive or negative percentage that represents the
-- increment or decrement on the current volume.
setVol :: String -> String
setVol x = "pactl set-sink-volume @DEFAULT_SINK@ " ++ x

setMute :: Bool -> String
setMute x = "pactl set-sink-mute @DEFAULT_SINK@ " ++ show (if x then 1 else 0)

playVolTest :: String
playVolTest = "canberra-gtk-play -i audio-volume-change"
