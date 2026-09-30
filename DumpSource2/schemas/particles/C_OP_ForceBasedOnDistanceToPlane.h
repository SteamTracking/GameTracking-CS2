// MHasKV3TransferPolymorphicClassname
class C_OP_ForceBasedOnDistanceToPlane : public CParticleFunctionForce
{
	// MPropertyFriendlyName = "min distance from plane"
	float32 m_flMinDist;
	// MPropertyFriendlyName = "force at min distance"
	// MVectorIsCoordinate
	Vector m_vecForceAtMinDist;
	// MPropertyFriendlyName = "max distance from plane"
	float32 m_flMaxDist; // = 1
	// MPropertyFriendlyName = "force at max distance"
	// MVectorIsCoordinate
	Vector m_vecForceAtMaxDist;
	// MPropertyFriendlyName = "plane normal"
	// MVectorIsCoordinate
	Vector m_vecPlaneNormal; // = [ 0, 0, 1 ]
	// MPropertyFriendlyName = "control point number"
	int32 m_nControlPointNumber;
	// MPropertyFriendlyName = "exponent"
	float32 m_flExponent; // = 1
};
