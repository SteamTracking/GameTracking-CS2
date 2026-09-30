// MPropertyFriendlyName = "Slow Down On Slopes"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_SlowDownOnSlopesNode : public CAnimGraphDoc_Node
{
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_inputConnection;
	// MPropertyFriendlyName = "Slow Down Strength"
	// MPropertyAttributeRange = "0.1 2"
	float32 m_flSlowDownStrength; // = 1
};
