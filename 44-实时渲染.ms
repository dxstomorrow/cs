if (renderers.current as string) == ((FStormRender as string) + ":" + (FStormRender as string)) then
(
    actionMan.executeAction 24328906 "40004"  -- FStorm: FStorm RT mode
    actionMan.executeAction 24328906 "40008"  -- FStorm: 恢复渲染
)
else
(
    actionMan.executeAction 572340868 "10"
)