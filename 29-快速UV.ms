

rcmenu r
( 
	menuitem t_1000 "1000"
	menuitem t_1500 "1500"
	menuitem t_2000 "2000"
	menuitem t_2500 "2500"
	menuitem t_3000 "3000"
	menuitem t_pp "长方体匹配"

	on t_1000 picked do
	(
		modPanel.addModToSelection (Uvwmap maptype:4 length:1000 width:1000 height:1000) ui:on
	)
	on t_1500 picked do
	(
		modPanel.addModToSelection (Uvwmap maptype:4 length:1500 width:1500 height:1500) ui:on
	)
	on t_2000 picked do
	(
		modPanel.addModToSelection (Uvwmap maptype:4 length:2000 width:2000 height:2000) ui:on
	)
	on t_2500 picked do
	(
		modPanel.addModToSelection (Uvwmap maptype:4 length:2500 width:2500 height:2500) ui:on
	)
	on t_3000 picked do
	(
		modPanel.addModToSelection (Uvwmap maptype:4 length:3000 width:3000 height:3000) ui:on
	)
	on t_pp picked do
	(   
		modPanel.addModToSelection (Uvwmap ()) ui:on 
			if selection.count > 0 then
		selection[1].modifiers[#UVW_Map].maptype = 4
	)
)

popUpMenu r pos:mouse.screenpos