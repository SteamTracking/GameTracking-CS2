// MPropertyFriendlyName = "Parameter Blender"
// MPropertyDescription = "Blends two containers according to parameter curves."
// MHasKV3TransferPolymorphicClassname
class CVoiceContainerParameterBlender : public CVoiceContainerBase
{
	// MPropertyFriendlyName = "First Sound"
	CSoundContainerReference m_firstSound;
	// MPropertyFriendlyName = "Second Sound"
	CSoundContainerReference m_secondSound;
	// MPropertyStartGroup = "Occlusion"
	// MPropertyFriendlyName = "Enable Occlusion Blend"
	bool m_bEnableOcclusionBlend;
	// MPropertySuppressExpr = "m_bEnableOcclusionBlend == false"
	// MPropertyFriendlyName = "First Curve"
	CPiecewiseCurve m_curve1;
	// MPropertySuppressExpr = "m_bEnableOcclusionBlend == false"
	// MPropertyFriendlyName = "Second Curve"
	CPiecewiseCurve m_curve2;
	// MPropertyStartGroup = "Distance"
	// MPropertyFriendlyName = "Enable Distance Blend"
	bool m_bEnableDistanceBlend;
	// MPropertySuppressExpr = "m_bEnableDistanceBlend == false"
	// MPropertyFriendlyName = "First Curve"
	CPiecewiseCurve m_curve3;
	// MPropertySuppressExpr = "m_bEnableDistanceBlend == false"
	// MPropertyFriendlyName = "Second Curve"
	CPiecewiseCurve m_curve4;
};
