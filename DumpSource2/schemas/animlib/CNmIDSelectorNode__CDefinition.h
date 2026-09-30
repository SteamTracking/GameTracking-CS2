// MHasKV3TransferPolymorphicClassname
class CNmIDSelectorNode::CDefinition : public CNmIDValueNode::CDefinition
{
	CUtlLeanVectorFixedGrowable< int16, 5 > m_conditionNodeIndices;
	CUtlLeanVectorFixedGrowable< CGlobalSymbol, 5 > m_values;
	CGlobalSymbol m_defaultValue;
};
