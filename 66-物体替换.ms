(
	global MakeiTInstance, MiTidialogPos
	on isEnabled return selection.count != 0
	on execute do  (
		try(destroydialog MakeiTInstance)catch()
		if classof MiTidialogPos != point2 then MiTidialogPos = unsupplied
		rollout MakeiTInstance "物体替换" width:170 height:85  
		(
			pickbutton source_btn "拾取源对象" pos:[5,5] width:160 height:25 autoDisplay:on enabled:false
			button Instance_btn "替换所选对象" pos:[5,35] width:160 height:45 enabled:false
			
			local source
			on source_btn picked obj do (
				if isvalidobj obj then (
					source = obj
					if isGroupMember source and not isOpenGroupMember source then (
						if queryBox "使用该组作为源对象还是仅使用拾取的对象？" then (
							if isValidNode source.parent and classof source.parent == Dummy then source = source.parent
							source_btn.caption = source.name
						)
					)
					Instance_btn.enabled = true
				)
			)
			on Instance_btn pressed do undo "MakeiT Instance" on (
				if isvalidobj source and selection.count > 0 do (
       				local new_nodes = #(), state = false, TargetState = false, InstancedObj, mtx, insDis, SelDis
					--Check Target State
					if (hasProperty source #Targeted and getProperty source #Targeted) or \
						(iskindof source light and isValidNode source.target) do TargetState = true
					--
					local SelectedObjs = for i in selection where isOpenGroupMember i or not isGroupMember i collect i
					if (idx = findItem SelectedObjs source) != 0 do (deleteItem SelectedObjs idx ; state = true)
					if SelectedObjs.count != 0 then (
	     		    	for i = 1 to SelectedObjs.count do (
							if isOpenGroupHead SelectedObjs[i] do (setGroupOpen SelectedObjs[i] false)
							maxOps.cloneNodes source cloneType:#instance newNodes:&new
							InstancedObj = new[1]
							append new_nodes InstancedObj
							InstancedObj.transform = SelectedObjs[i].transform
							if isOpenGroupMember SelectedObjs[i] then try(attachNodesToGroup InstancedObj SelectedObjs[i].parent)catch()
							--Fix Target Transfom
							if TargetState do (
								insDis = distance InstancedObj InstancedObj.target
								InstancedObj.target.transform = SelectedObjs[i].transform
								if (hasProperty SelectedObjs[i] #Targeted and getProperty SelectedObjs[i] #Targeted) or \
								(iskindof SelectedObjs[i] light and isValidNode SelectedObjs[i].target) then (
									SelDis = distance SelectedObjs[i] SelectedObjs[i].target
									in coordsys InstancedObj.target.transform move InstancedObj.target [0,0,-SelDis]
									if isOpenGroupMember SelectedObjs[i].target do try(attachNodesToGroup InstancedObj.target SelectedObjs[i].target.parent)catch()
								)
								else (
									in coordsys InstancedObj.target.transform move InstancedObj.target [0,0,-insDis]
								)
							)
						)
						delete SelectedObjs
						select new_nodes
					)
					else if state do messageBox "The Source and Target Objects are the Same !!"
				)
			)
			on MakeiTInstance open do (
				if selection.count != 0 then source_btn.enabled = true
			)
			on MakeiTInstance mousemove pos do (
				if selection.count != 0 then (
					if not source_btn.enabled then source_btn.enabled = true
				)
				else if source_btn.enabled then source_btn.enabled = false
			)
			on MakeiTInstance close do (MiTidialogPos = GetDialogPos MakeiTInstance)
		)
		createdialog MakeiTInstance pos:MiTidialogPos
		clearListener()
	)
)