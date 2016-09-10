-- TODO: Consider replacing Gnome taskbar with xmobar (task switcher and workspace list)
-- TODO: Consider using UpdatePointer so mouse follows active window focus.

import XMonad
import qualified XMonad.StackSet as W
import XMonad.Config.Gnome (gnomeConfig, gnomeRun)
import XMonad.Layout.NoBorders (noBorders)
import XMonad.Layout.Spacing (spacing)
import XMonad.Layout.IndependentScreens
import XMonad.Config.Desktop (desktopLayoutModifiers)
import XMonad.Hooks.SetWMName
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Util.Run (spawnPipe)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import System.IO
import XMonad.Actions.PhysicalScreens

main = do
    --xmproc <- spawnPipe "xmobar -b -d"
    nScreens <- countScreens
    xmonad $ gnomeConfig
        { modMask = myModMask
        , layoutHook = myLayouts
        , startupHook = do 
            startupHook gnomeConfig
            setWMName "LG3D"
        , manageHook = manageDocks <+> myManageHook <+> manageHook gnomeConfig
        --, manageHook = manageDocks <+> manageHook gnomeConfig
        --, logHook = dynamicLogWithPP xmobarPP
        --    { ppOutput = hPutStrLn xmproc
        --    , ppTitle = xmobarColor "green" "" . shorten 50
        --    }
        , workspaces = myWorkspaces nScreens
        , terminal = "x-terminal-emulator"
        , borderWidth = 1
        --, focusedBorderColor = "#AF0000"
        } `additionalKeys` myKeys

myModMask = mod4Mask

myLayouts = desktopLayoutModifiers (tiled ||| Mirror tiled ||| full)
    where
        tiled = spacing 12 $ Tall 1 (1/100) (1/2)
        full = noBorders Full

workSpaceNames = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

myWorkspaces nScreens = withScreens nScreens workSpaceNames

myKeys =
        -- use Win-o rather than Win-p for gnomeRun to work around this bug:
        -- http://ubuntuforums.org/showthread.php?t=2158104&p=12859037#post12859037
        [ ((mod4Mask, xK_o), gnomeRun)
        ]
        ++
        -- screen switch keys assigned based on physical arrangement of screens
        [ ((m .|. myModMask, key), f sc)
             | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
             , (f, m) <- [(viewScreen, 0), (sendToScreen, shiftMask)]
        ]
        ++
        -- workspaces are distinct by screen
        [ ((m .|. myModMask, k), windows $ onCurrentScreen f i)
             | (i, k) <- zip workSpaceNames [xK_1 .. xK_9]
             , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
        ]

myManageHook = composeAll
               [ className =? "Guake" --> doFloat
               , className =? "Tilda" --> doFloat
               , className =? "Tomboy"   --> doFloat
               , className =? "Update-manager" --> doFloat
               , resource =? "synapse" --> doIgnore
               ]
