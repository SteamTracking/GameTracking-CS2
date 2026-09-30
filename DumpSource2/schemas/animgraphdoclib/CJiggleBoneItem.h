// MPropertyFriendlyName = "Item"
// MPropertyElementNameFn
class CJiggleBoneItem
{
	// MPropertyFriendlyName = "Bone"
	// MPropertyAttributeChoiceName = "Bone"
	CUtlString m_boneName;
	// MPropertyFriendlyName = "Spring Strength"
	float32 m_flSpringStrength; // = 10
	// MPropertyFriendlyName = "Sim Rate (FPS)"
	float32 m_flSimRateFPS; // = 90
	// MPropertyFriendlyName = "Damping"
	// MPropertyAttributeRange = "0 1"
	float32 m_flDamping; // = 0.01
	// MPropertyFriendlyName = "Sim Space"
	JiggleBoneSimSpace m_eSimSpace; // = "SimSpace_World"
	// MPropertyFriendlyName = "Max"
	// MPropertyGroupName = "Movement Limits"
	Vector m_vBoundsMaxLS; // = [ 10, 10, 10 ]
	// MPropertyFriendlyName = "Min"
	// MPropertyGroupName = "Movement Limits"
	Vector m_vBoundsMinLS; // = [ -10, -10, -10 ]
};
