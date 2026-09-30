// MPropertyFriendlyName = "Solve IK Chain"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_SolveIKChainNode : public CAnimGraphDoc_Node
{
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_inputConnection;
	// MPropertyFriendlyName = "IK Chains"
	// MPropertyAutoExpandSelf
	CUtlVector< CSolveIKChainAnimNodeChainData > m_IkChains;
};
