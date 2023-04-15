
(
	clearListener()
	
	function rapidEdit modObj =
	(
		if getCommandPanelTaskMode() != #modify then setCommandPanelTaskMode #modify
		if modPanel.getCurrentObject() != modObj then modPanel.setCurrentObject modObj
		
		subObjectLevel = 1
	)
	
	if selection.count > 1 then
	(
		if getCommandPanelTaskMode() != #modify then setCommandPanelTaskMode #modify
		if subObjectLevel == 0 then
		(
			local bModApplied = false
			for obj in selection where obj.modifiers[obj.modifiers.count] != undefined and obj.modifiers[obj.modifiers.count] == selection[1].modifiers[selection[1].modifiers.count] do bModApplied = true
			
			if not bModApplied then
			(
				
				if getCommandPanelTaskMode() != #modify then setCommandPanelTaskMode #modify
				local modObj = Edit_Poly()
				modPanel.addModToSelection modObj ui:on
				subObjectLevel = 1
			)
			else
			(
				
				subObjectLevel = 1
			)
		)
		else
		(
			
			subObjectLevel = 0
		)
	)
	else if selection.count == 1 then
	(
		local obj = selection[1]
		if getCommandPanelTaskMode() == #modify and subObjectLevel != 0 then
		(
			subObjectLevel = 0
			modPanel.setCurrentObject obj.modifiers[1]
		)
		else
		(
			local bModFound = false
			for nMod=1 to obj.modifiers.count while not bModFound do
			(
				local modObj = obj.modifiers[nMod]
				local nModType = findItem #(Edit_Poly, Edit_Spline) (classof modObj)
				
				if nModType != 0 then
				(
					rapidEdit modObj
					bModFound = true
				)
			)
			
			local bBaseObjectEditable = false
			if findItem #(Editable_Poly, Editable_Mesh, /* SplineShape, */ line) (classof obj.baseObject) != 0 then bBaseObjectEditable = true
			
			-- edit baseobject
			if bBaseObjectEditable and not bModFound then
			(
				rapidEdit obj
			)
			else if not bModFound then
			(
				if superclassof obj.baseObject == shape then
				(
					if classof obj.modifiers[1] == Extrude then
					(
						modObj = Edit_Poly()
						try 
						(
							---addModifier obj modObj---
							macros.run "Modifier Stack" "Convert_to_Poly"
							if getCommandPanelTaskMode() != #modify then setCommandPanelTaskMode #modify
							subObjectLevel = 1
						)
						catch()
					)
					else
					(
						modObj = Edit_Spline()
						try 
						(
							---addModifier obj modObj---
							macros.run "Modifier Stack" "Convert_to_Spline"
							if getCommandPanelTaskMode() != #modify then setCommandPanelTaskMode #modify
							subObjectLevel = 1
						)
						catch()
					)
				)
				else
				(
					if superclassof obj.baseObject == geometryClass do
					(
						modObj = Edit_Poly()
						try 
						(
							---addModifier obj modObj---
							macros.run "Modifier Stack" "Convert_to_Poly"
							if getCommandPanelTaskMode() != #modify then setCommandPanelTaskMode #modify
							subObjectLevel = 1
						)
						catch()
					)
				)				
			)
		)
	)
)