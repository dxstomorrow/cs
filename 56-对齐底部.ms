/*
This is an update of the script "Move To Surface",
You can check the YouTube demo here: https://youtu.be/dKNKQDGJkv4

To use it, select a collection of objects, click the script, pick a target geometry to drop the selected objects onto.
This updated version will consider the presence of groups, or/and objects that are in a heirarchy and will drop the topmost parent.

script created by Miled Rizk
e-mail: miledrizk@gmail.com
*/
(
	
	function FindTopMostGroupHead obj = 
	(
		if isGroupMember obj then
			while obj != undefined and (not isGroupHead obj or isGroupMember obj) do (obj = obj.parent)
		else
			obj
		obj
	)
	
	function SetPivotMinCenterMax obj =
	(
		oCenter = obj.center
		pivMin = [oCenter.x, oCenter.y, obj.min.z]
		pivMax = [oCenter.x, oCenter.y, obj.max.z]
		distC = distance obj.pivot oCenter
		distMin = distance obj.pivot pivMin
		distMax = distance obj.pivot pivMax
	      (obj.pivot = pivMin)
	)
	
	allObjsArr = selection as array
	grpHeadsArr = #()
	singleObjsArr = #()
	for o in allObjsArr do
	(
		grpHead = FindTopMostGroupHead o
		if isGroupHead grpHead then
			appendIfUnique grpHeadsArr grpHead
		else
			append singleObjsArr grpHead
	)
	
	if grpHeadsArr.count != 0 do
	(
		toolMode.pivotCenter()
		for o in grpHeadsArr do
			SetPivotMinCenterMax o
	)
			
	if singleObjsArr.count != 0 do
		for o in singleObjsArr do SetPivotMinCenterMax o
	
)

(

	fn geometryfilter obj = superclassof obj == geometryclass	--this function will check if the target mesh is a geometry object
		
	fn get_parent_object obj = 	--this function will return the topmost node of a hierarchy. we use recursion to accomplish this task
	(
		p_obj = obj.parent
		if p_obj != undefined then
		(
			p_obj = get_parent_object p_obj
		)--end if
		else
		(
			p_obj = obj
		)--end else
	)--end fn 
		
	fn find_intersection targetmesh obj_todrop =
	(
		try
		(
			local test_ray = ray obj_todrop.pos [0,0,-1]
			local max_z = targetmesh.max.z
			test_ray.pos.z = max_z + 0.1
			intersectray targetmesh test_ray
		)--end try
		catch()
	)--end find_intersection

	On Isenabled return selection.count > 0		--the script is available only if at least when object is selected

	On Execute do
	(
		target_mesh = pickobject message: "Pick target object" filter: geometryfilter

		if isvalidnode target_mesh do
		(
			undo "MoveToSurface" on
			(
				max create mode	--we switch to create mode for faster execution
				for i in selection do
				(
					if i.parent != undefined do	--if the object has a parent we call the function "get_parent_object" to get the topmost parent node and move that only
					(
						i = get_parent_object i
					)--end if
					
					i.pivot = i.center
					i.pivot.z = i.min.z
					intersectionpoint = find_intersection target_mesh i
					if intersectionpoint != undefined do
					(
						i.pos = intersectionpoint.pos
					)--end if
				)--end for
			)--end undo on
		)--end if
	)--end on execute
)--end macroscript