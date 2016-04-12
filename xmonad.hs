{-# LANGUAGE RecordWildCards #-}
import XMonad
import XMonad.Layout
import XMonad.Layout.ResizableTile
--import XMonad.Layout.Spiral
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run(safeSpawnProg, runInTerm)
import qualified Data.Map as M
import Graphics.X11.ExtraTypes.XF86( xF86XK_AudioRaiseVolume
                                   , xF86XK_AudioLowerVolume
                                   , xF86XK_AudioMute
                                   , xF86XK_MonBrightnessDown
                                   , xF86XK_MonBrightnessUp
                                   )

keyLayout = keys defaultConfig <+> \conf@(XConfig { .. })
   -> M.fromList
      [ ((0, xF86XK_AudioRaiseVolume), spawn "amixer set Master 4+")
      , ((0, xF86XK_AudioLowerVolume), spawn "amixer set Master 4-")
      , ((0, xF86XK_AudioMute), spawn "amixer set Master toggle")

      , ((shiftMask, xF86XK_AudioRaiseVolume), spawn "amixer set Master 2+")
      , ((shiftMask, xF86XK_AudioLowerVolume), spawn "amixer set Master 2-")
      , ((modMask .|. shiftMask, xK_f), safeSpawnProg "chromium")
      , ((modMask .|. shiftMask, xK_h), runInTerm "-title htop" "sh -c 'htop'")

      , ((0, xF86XK_MonBrightnessDown), spawn "xbacklight -dec 1 -time 0 -steps 5")
      , ((0, xF86XK_MonBrightnessUp), spawn "xbacklight -inc 1 -time 0 -steps 5")

      , ((modMask, xK_F12), spawn scrotMouse)
      , ((modMask, xK_F11), spawn scrot)

      , ((modMask .|. shiftMask, xK_z),
              runInTerm "-title emacs" "bash -c 'export TERM=xterm-256color && emacsclient -tty'")
      , ((modMask .|. shiftMask, xK_minus), sendMessage MirrorShrink)
      , ((modMask .|. shiftMask, xK_equal), sendMessage MirrorExpand)]

layout = ResizableTall 1 (3/100) (1/2) []
         ||| Mirror tiled
         ||| Full
--         ||| spiral (3/7)
    where
      -- default tiling algorithm partitions the screen into two panes
      tiled   = Tall nmaster delta ratio
      nmaster = 1     -- the default number of windows in the master pane
      ratio   = 1/2   -- default proportion of screen occupied by master pane
      delta   = 3/100 -- percent of screen to increment by when resizing panes

scrot = "scrot -e 'mkdir -p ~/scrot && mv $f ~/scrot'"
scrotMouse = "sleep 0.2; " ++ scrot ++ " -s"

main = xmonad =<< xmobar defaultConfig
       { terminal    = "xterm"
       , borderWidth = 0
       , keys = keyLayout
       , layoutHook = layout
       }
