// MHasKV3TransferPolymorphicClassname
class CNmBoneMaskSelectorNode::CDefinition : public CNmBoneMaskValueNode::CDefinition
{
	int16 m_defaultMaskNodeIdx; // = -1
	int16 m_parameterValueNodeIdx; // = -1
	bool m_bSwitchDynamically;
	CUtlLeanVectorFixedGrowable< int16, 8 > m_maskNodeIndices;
	CUtlLeanVectorFixedGrowable< CGlobalSymbol, 7 > m_parameterValues;
	float32 m_flBlendTimeSeconds; // = 0.1
};
