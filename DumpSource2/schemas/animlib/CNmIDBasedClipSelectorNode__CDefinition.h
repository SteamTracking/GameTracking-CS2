// MHasKV3TransferPolymorphicClassname
class CNmIDBasedClipSelectorNode::CDefinition : public CNmClipReferenceNode::CDefinition
{
	CUtlLeanVectorFixedGrowable< int16, 5 > m_optionNodeIndices;
	CUtlLeanVectorFixedGrowable< CGlobalSymbol, 5 > m_optionIDs;
	int16 m_nParameterNodeIdx; // = -1
	int16 m_nFallbackNodeIdx; // = -1
	bool m_bIgnoreInvalidOptions;
};
