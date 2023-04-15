CurRender = ""

case of -- detect Render Engine
(
	(matchpattern (renderers.current as string) pattern:"*Ray*" == true): CurRender = "Vray"
	(matchpattern (renderers.current as string) pattern:"*Fstorm*" == true): CurRender = "FStorm"
	(matchpattern (renderers.current as string) pattern:"*Coro*" == true):  CurRender = "Corona"
	(matchpattern (renderers.current as string) pattern:"*Redshif*" == true):  CurRender = "Redshift"
	default: CurRender = ""
)


if CurRender == "FStorm" do
(
	if classof (renderers.current.environment_texture) == FStormBitmap do
	(
		if $EnvironmentManipulator != null do (delete $EnvironmentManipulator)
		
		EnvSlider = sliderManipulator xPos:0.65 yPos:0.1 sldName:"HDRI" width:200 minVal:-1 maxVal:1 value:(renderers.current.environment_texture.offset[1])
		EnvSlider.name = "EnvironmentManipulator"

		
		env_p1_ctrl = Bezier_Float()	
		env_p3_ctrl = Point3_XYZ ()
		
		$EnvironmentManipulator.value.controller = env_p1_ctrl
		env_p3_ctrl.X.controller = env_p1_ctrl
		renderers.current.environment_texture.offset.controller = env_p3_ctrl
		
		actionMan.executeAction 0 "59225"  -- Tools: Select and Manipulate

	)
)

if CurRender == "Corona" do
(
	if classof (renderers.current.bg_texmap) == CoronaBitmap and renderers.current.bg_source == 1 do
	(
		if $EnvironmentManipulator != null do (delete $EnvironmentManipulator)
		
		EnvSlider = sliderManipulator xPos:0.7 yPos:0.1 sldName:"HDRI" width:200 minVal:-1 maxVal:1 value:(renderers.current.bg_texmap.uvwOffset[1])
		EnvSlider.name = "EnvironmentManipulator"

		
		env_p1_ctrl = Bezier_Float()	
		env_p3_ctrl = Point3_XYZ ()
		
		$EnvironmentManipulator.value.controller = env_p1_ctrl
		env_p3_ctrl.X.controller = env_p1_ctrl
		renderers.current.bg_texmap.uvwOffset.controller = env_p3_ctrl
		
		actionMan.executeAction 0 "59225"  -- Tools: Select and Manipulate

	)
)

if CurRender == "Vray" do
(
	VRAYHDRI_Light = null
	VrayLights = (for o in Lights where classof o == VrayLight collect o)	

	for o in VrayLights where o.on == on and o.type == 1 and o.texmap_on == on and o.texmap != null do 
	(
		if classof (o.texmap) == VRayBitmap or classof (o.texmap) == VRayHdri do
		(
			VRAYHDRI_Light = o
			--print VRAYHDRI_Light
		)
		
	)


	
	if VRAYHDRI_Light != null and VRAYHDRI_Light.texmap_locktodome == 0 do
	(
		if $EnvironmentManipulator != null do (delete $EnvironmentManipulator)
		
		EnvSlider = sliderManipulator xPos:0.7 yPos:0.1 sldName:"HDRI" width:200 minVal:-6.283 maxVal:6.283 --value:(VRAYHDRI_Light.texmap.horizontalRotation)
		EnvSlider.name = "EnvironmentManipulator"
		
		env_p1_ctrl = Linear_Float()
		
		$EnvironmentManipulator.value.controller = env_p1_ctrl
		VRAYHDRI_Light.texmap.horizontalRotation.controller = env_p1_ctrl
		
		actionMan.executeAction 0 "59225"  -- Tools: Select and Manipulate
	)
	if VRAYHDRI_Light != null and VRAYHDRI_Light.texmap_locktodome == 1 do
	(
		if $EnvironmentManipulator != null do (delete $EnvironmentManipulator)
		
		EnvSlider = sliderManipulator xPos:0.7 yPos:0.1 sldName:"HDRI" width:200 minVal:-6.283 maxVal:6.283 --value:(VRAYHDRI_Light.rotation.z_rotation)
		EnvSlider.name = "EnvironmentManipulator"
		
		env_p1_ctrl = Bezier_Float()
		
		$EnvironmentManipulator.value.controller = env_p1_ctrl
		VRAYHDRI_Light.rotation.controller.Z_Rotation.controller = env_p1_ctrl
		
		actionMan.executeAction 0 "59225"  -- Tools: Select and Manipulate
	)
)
if keyboard.shiftpressed then select $EnvironmentManipulator 
delete $