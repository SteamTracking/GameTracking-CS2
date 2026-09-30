// MHasKV3TransferPolymorphicClassname
class CNmGraphDocFlowNode : public CNmGraphDocNode
{
	CUtlLeanVectorFixedGrowable< NmGraphDocPin_t, 4 > m_inputPins;
	CUtlLeanVectorFixedGrowable< NmGraphDocPin_t, 1 > m_outputPins;
};
