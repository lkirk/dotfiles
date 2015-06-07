{-# LANGUAGE RecordWildCards #-}

import XMonad
import XMonad.Hooks.DynamicLog
import Graphics.X11.ExtraTypes.XF86
import qualified Data.Map as M

main = xmonad =<< xmobar defaultConfig
       { terminal    = "urxvt"
       , borderWidth = 0
       , keys = keys defaultConfig <+> \conf@(XConfig { .. })
              -> M.fromList
                [ ((0, xF86XK_AudioRaiseVolume), spawn "amixer set Master 5+")
                , ((0, xF86XK_AudioLowerVolume), spawn "amixer set Master 5-")
                , ((0, xF86XK_AudioMute),        spawn "amixer set Master toggle")
                -- , ((modMask .|. shiftMask, xF86XK_AudioRaiseVolume), spawn "amixer set Master 2+")
                -- , ((modMask .|. shiftMask, xF86XK_AudioLowerVolume), spawn "amixer set Master 2-")
                -- , ((modMask .|. shiftMask, xF86XK_AudioMute),        spawn "amixer set Speaker toggle")
                ]
       }
