// MPropertyFriendlyName = "Path Helper"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_PathHelperNode : public CAnimGraphDoc_Node
{
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_inputConnection;
	// MPropertyFriendlyName = "Stopping Radius"
	float32 m_flStoppingRadius; // = 36
	// MPropertyFriendlyName = "Stopping Min Speed Scale"
	float32 m_flStoppingSpeedScale; // = 1
};
