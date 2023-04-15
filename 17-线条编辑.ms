
rcmenu r
(
	menuitem t_JD "加点"
	menuitem t_DK "断开"
	menuitem t_BJ "标点"
	menuitem t_HJ "焊接"
	menuitem t_LJ "连接"
      seperator menuSep01
	menuitem t_YJ "圆角"
	menuitem t_QJ "切角"
      seperator menuSep02
	menuitem t_XJ "修剪"
	menuitem t_YS "延伸"
	menuitem t_LK "轮廓"
      seperator menuSep03
	menuitem t_FL "分离"
	menuitem t_FJ "附加"


	on t_JD picked do
	(
		undo on
		(
			try
			(
			   for s in selection do 
			   (
				 macros.run "Modifier Stack" "Convert_to_Spline"
				 subobjectlevel = 1
				 ApplyOperation Edit_Spline Splineops.startRefine
				 updateShape s
			   )
			) 
			catch()
		)
	)
	on t_DK picked do
	(
		undo on
		(
			try
			(
			   for s in selection do 
			   (
				 macros.run "Modifier Stack" "Convert_to_Spline"
				 subobjectlevel = 1
				 ApplyOperation Edit_Spline Splineops.startBreak
				 updateShape s
			   )
			) 
			catch()
		)
	)
	on t_BJ picked do
	(
	      with undo on
		(
			if  selection.count ==1 then
			(
					if superclassOf $ == shape then
					(
					macros.run "Modifier Stack" "Convert_to_Spline"
					for s in 1 to (numsplines $) do
					(	
						if numknots $ s != numsegments $ s then 
						(
						ver_pos = for aa = 1 to s collect getKnotPoint $ s 1
						poit = Point pos:ver_pos[1] wirecolor:yellow
						poit.centermarker = off
						poit.axistripod = off						
						poit.cross = off
						poit.Box = on 	
						poit.size = 8
						poit.constantscreensize = on
						poit.drawontop = off	
						poit.name = uniquename "XXX_"
						ver_pos = for aa = 1 to s collect getKnotPoint $ s (numknots $ s)
						poit = Point pos:ver_pos[1] wirecolor:white
						poit.centermarker = off
						poit.axistripod = off						
						poit.cross = off
						poit.Box = on 	
						poit.size = 8
						poit.constantscreensize = on
						poit.drawontop = off	
						poit.name = uniquename "XXX_"
						)
					)
					)
			)
		
		)
	)
	on t_HJ picked do
	(
		undo on
		(
			try
			(
				for s in selection do 
				(
					max modify mode
					subobjectlevel = 1
					ApplyOperation Edit_Spline Splineops.weld
					updateShape s
				)
			) 
			catch()
		)
	)
	on t_LJ picked do
	(
		try (
		sel = #()		
		for i=1 to (numSplines $) do
		(
			sels = getKnotSelection $ i
			if sels.count > 0 then 
			(
				for j in sels do 
					append sel (getKnotPoint $ i j)
			)
		)
		updateShape $
				
		if sel.count == 2 then 
		(
			aa = SplineShape pos:sel[1]
			addNewSpline aa
			addKnot aa 1 #corner #line sel[1]
			addKnot aa 1 #corner #line sel[2]
			updateShape aa
			addAndWeld $ aa 1.0
			updateShape $
			max select none
		)
		)
		catch()
	)

	on t_YJ picked do
	(
		undo on
		(
			try
			(
				for s in selection do 
				(
					macros.run "Modifier Stack" "Convert_to_Spline"
					subobjectlevel = 1
					ApplyOperation Edit_Spline Splineops.startFillet
					updateShape s
				)
			) 
			catch()
		)
	)
	on t_QJ picked do
	(
		undo on
		(
			try
			(
				for s in selection do 
				(
					macros.run "Modifier Stack" "Convert_to_Spline"
					subobjectlevel = 1
					ApplyOperation Edit_Spline Splineops.startChamfer
					updateShape s				
				)
			) 
			catch()
		)
	)
	on t_XJ picked do
	(
		with undo on
		(
			try
			(
			    for s in selection do 
			    (
				 macros.run "Modifier Stack" "Convert_to_Spline"
				 subobjectlevel = 3
				 ApplyOperation Edit_Spline Splineops.startTrim
				 updateShape s
			    )
			) 
			catch()
		)
	)
	on t_YS picked do
	(
		with undo on
		(
			try
			(
			    for s in selection do 
			    (
				 macros.run "Modifier Stack" "Convert_to_Spline"
				 subobjectlevel = 3
				 ApplyOperation Edit_Spline Splineops.startExtend
				 updateShape s
			    )
			) 
			catch()
		)
	)
	on t_LK picked do
	(
		with undo on
		(
			try
			(
			    for s in selection do 
			    (
				 macros.run "Modifier Stack" "Convert_to_Spline"
				 subobjectlevel = 3
				 ApplyOperation Edit_Spline Splineops.startOutline
				 updateShape s
			    )
			) 
			catch()
		)
	)
	on t_FL picked do
	(
		objs = for i in selection where superclassof i == shape collect i
		allL = #()
		for obj in objs do 
		(
			convertToSplineShape obj
			if  numSplines obj != 1 then 
		  (
				num = #{1..numSplines obj} as array
				
			for i = 1 to num.count do
			(
				newL = copy obj
				newL.wirecolor = obj.wirecolor
				for a = (numSplines newL) to 1 by -1 do (
					if a != num[i] then deleteSpline newL a
					)
				updateShape newL
				append allL newL
			)
			delete obj
		  )
		)
		select allL
	)
	on t_FJ picked do
	(
		try(max modify mode
		ApplyOperation Edit_Spline Splineops.startAttach) catch()
	)
)

popUpMenu r pos:mouse.screenpos