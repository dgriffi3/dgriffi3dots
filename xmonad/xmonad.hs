import XMonad
import qualified XMonad.StackSet as W

import XMonad.Layout.Grid
import XMonad.Layout.NoBorders(smartBorders)

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers

import XMonad.Hooks.SetWMName

import XMonad.Layout.ResizableTile -- resize non-master windows too

import Data.Char
import Data.List

import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeysP)
import XMonad.Util.Scratchpad
import XMonad.Util.Loggers

import XMonad.Prompt
import XMonad.Prompt.Shell(shellPrompt)
import XMonad.Prompt.Window

import System.IO(hPutStrLn)

myLayoutHook = Full ||| tiled ||| Mirror tiled ||| Grid
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled   = Tall nmaster delta ratio
              
    -- The default number of windows in the master pane
    nmaster = 1

    -- Default proportion of screen occupied by master pane
    ratio   = 1/2

    -- Percent of screen to increment by when resizing panes
    delta   = 3/100

-- MyFloatsC and T are match-anywher
myManageHook = composeAll . concat $
               [ performInfixOn doFloat myFloatsC className
               , performInfixOn doFloat myFloatsT title
               , performInfixOn doCenterFloat myCenterFloatsC className
               , performInfixOn doCenterFloat myCenterFloatsT title
               , [ manageDocks ]
               , [ scratchpadManageHook (W.RationalRect 0.1 0.1 0.8 0.8) ]
               ]
  where myFloatsC = [ ]
        myFloatsT = [ ]
        myCenterFloatsC = [ ]
        myCenterFloatsT = [ "NVidia" ]
        performInfixOn action list matchType =
          [ fmap ( c `isInfixOf`) matchType --> action | c <- list ]

main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $ defaultConfig
           { manageHook = myManageHook <+> manageHook defaultConfig
           , layoutHook = avoidStruts  $  smartBorders $ myLayoutHook
           , logHook    = dynamicLogWithPP $ xmobarPP
                          { ppOutput = hPutStrLn xmproc
                          , ppExtras = [ battery ]
                          , ppTitle  = xmobarColor "#8AE234" "" . filter (\c -> ord c < 128) ---
                          }
           , startupHook = setWMName "LG3D"
           , terminal = "urxvtc"
           , modMask = mod4Mask
           }
           `additionalKeysP`
           [ ("M-p", shellPrompt defaultXPConfig { position = Top })
           , ("M-S-a", windowPromptGoto defaultXPConfig { position = Top })
           , ("M-a", windowPromptBring defaultXPConfig { position = Top })
           , ("M-x", sendMessage ToggleStruts)
           , ("M-S-l", spawn "~/bin/lock")
--           , ("M-e", spawn "emacsclient -c")
           , ("M-f", spawn "firefox")
           , ("M-r", spawn "urxvtc")
           , ("M-S-t", spawn "trackpad-toggle") -- Turn on/off trackpad
           , ("M-g", scratchpadSpawnActionTerminal "urxvtc")
           ]
