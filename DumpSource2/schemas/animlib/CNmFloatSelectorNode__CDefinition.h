// MHasKV3TransferPolymorphicClassname
class CNmFloatSelectorNode::CDefinition : public CNmFloatValueNode::CDefinition
{
	CUtlLeanVectorFixedGrowable< int16, 5 > m_conditionNodeIndices;
	CUtlLeanVectorFixedGrowable< float32, 5 > m_values;
	float32 m_flDefaultValue;
	float32 m_flEaseTime; // = 0.2
	NmEasingOperation_t m_easingOp; // = "Linear"
};
