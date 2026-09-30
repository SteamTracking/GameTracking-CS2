// MPropertyFriendlyName = "Stop At Goal"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_StopAtGoalNode : public CAnimGraphDoc_Node
{
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_inputConnection;
	// MPropertyFriendlyName = "Outer Stopping Radius"
	float32 m_flOuterRadius; // = 120
	// MPropertyFriendlyName = "Inner Stopping Radius"
	float32 m_flInnerRadius; // = 40
	// MPropertyFriendlyName = "Maximum Speed Scale"
	float32 m_flMaxScale; // = 1.5
	// MPropertyFriendlyName = "Minimum Speed Scale"
	float32 m_flMinScale; // = 0.5
	// MPropertyFriendlyName = "Damping"
	CAnimInputDamping m_damping; // = { "_class": "CAnimInputDamping", "m_fFallingSpeedScale": 1, "m_fSpeedScale": 1, "m_speedFunction": "NoDamping" }
};
