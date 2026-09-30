// MHasKV3TransferPolymorphicClassname
class CNmGraphDocBlend1DNode : public CNmGraphDocFlowNode
{
	// MPropertyAttributeEditor = "BlendSpace1D()"
	CNmBlendSpace1D m_blendSpace; // = { "m_points": [ { "m_flValue": 0, "m_name": "Option", "m_pinID": "" }, { "m_flValue": 0, "m_name": "Option", "m_pinID": "" } ] }
	// MPropertyDescription = "When not being driven by a sync time, control looping behavior "
	bool m_bAllowLooping; // = true
};
