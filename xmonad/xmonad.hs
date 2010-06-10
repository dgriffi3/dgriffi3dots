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

import XMonad.Layout.NoBorders

import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeysP)
import XMonad.Util.Scratchpad
import XMonad.Util.Loggers

import XMonad.Prompt
import XMonad.Prompt.Shell(shellPrompt)
import XMonad.Prompt.Window

import System.IO(hPutStrLn)

myLayoutHook = Full

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
           , layoutHook = avoidStruts  $  noBorders $ myLayoutHook
           , logHook    = dynamicLogWithPP $ xmobarPP
           , startupHook = setWMName "LG3D" -- Hack to get Java to play nicely with xmonad
           , terminal = "urxvtcd"
           , modMask = mod4Mask
           , focusFollowsMouse = False
           }
           `additionalKeysP`
           [ ("M-f", spawn "firefox")
           , ("M-l", spawn "xlock")
           , ("M-g", scratchpadSpawnActionTerminal "urxvtcd")
           ]
