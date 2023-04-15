
if (renderers.current as string) == ((FStormRender as string) + ":" + (FStormRender as string)) then
(
    actionMan.executeAction 24328906 "40007"
)
else
(
    CoronaRenderer.CoronaFp.stopRender()
)