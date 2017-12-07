module XMonad.Util.AudioKeys
  (setVolFeedback, setMute)
  where

import Data.List

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
