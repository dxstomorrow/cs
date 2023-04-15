plugin modifier ChamferFix
name:"ChamferFix"
classID:#(1773753489L, 678499658L)
category:"standard"
extends:Chamfer
replaceUI:false
(
	on attachedToNode obj do
	(
		delegate.amount = 2.0
		delegate.segments = 2
		delegate.tension = 1.0
		delegate.openchamfer = false
		delegate.invert = false
		delegate.selectionoption = 0
		delegate.smoothingoption = 0
		delegate.materialoption = 0
		delegate.setmaterial = false
		delegate.materialID = 1
		delegate.smooth = true
		delegate.SmoothType = 1
		delegate.smooththreshold = 30.0
		delegate.chamfertype = 0
		delegate.limiteffect = false
		delegate.useminangle = true
		delegate.minangle = 20.0
		delegate.usemaxangle = false
		delegate.maxangle = 90.0
		delegate.smoothtoadjacent = false
		delegate.quadIntersectionMode = true
		delegate.miteringType = 1
		delegate.amountType = 0
		delegate.minAmount = 0.0
		delegate.maxAmount = 1.0
		delegate.addinset = false
		delegate.insetamount = 0.5
		delegate.insetsegments = 0
		delegate.insetoffset = 0.0
		delegate.forcePositiveOffset = false
		delegate.miterEndBias = 0.5
		delegate.useConstantOffset = false
		delegate.depth = 0.5
		delegate.presetOptionsComboBox = 0
		delegate.radiusBias = 0.0
		delegate.biasEndPoints = true
		delegate.scale = 1.0
		delegate.depthType = 0
		delegate.insetType = 0
		delegate.angleFactorVertex = 0.5
		replaceInstances this delegate
	)
)
modPanel.addModToSelection (ChamferFix ()) ui:on