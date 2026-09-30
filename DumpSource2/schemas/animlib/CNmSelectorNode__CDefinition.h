// MHasKV3TransferPolymorphicClassname
class CNmSelectorNode::CDefinition : public CNmPoseNode::CDefinition
{
	CUtlLeanVectorFixedGrowable< int16, 8 > m_optionNodeIndices;
	CUtlLeanVectorFixedGrowable< int16, 8 > m_conditionNodeIndices;
};
