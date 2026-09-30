// MHasKV3TransferPolymorphicClassname
class CNmClipSelectorNode::CDefinition : public CNmClipReferenceNode::CDefinition
{
	CUtlLeanVectorFixedGrowable< int16, 8 > m_optionNodeIndices;
	CUtlLeanVectorFixedGrowable< int16, 8 > m_conditionNodeIndices;
};
