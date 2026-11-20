// MHasKV3TransferPolymorphicClassname
class C_OP_PlanarConstraint : public CParticleFunctionConstraint
{
	// MPropertyFriendlyName = "plane point"
	// MVectorIsCoordinate
	Vector m_PointOnPlane;
	// MPropertyFriendlyName = "plane normal"
	Vector m_PlaneNormal; // = [ 0, 0, 1 ]
	// MPropertyFriendlyName = "control point number"
	int32 m_nControlPointNumber;
	// MPropertyFriendlyName = "global origin"
	bool m_bGlobalOrigin;
	// MPropertyFriendlyName = "global normal"
	bool m_bGlobalNormal;
	// MPropertyFriendlyName = "radius scale"
	CPerParticleFloatInput m_flRadiusScale; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "falloff distance from control point"
	CParticleCollectionFloatInput m_flMaximumDistanceToCP; // = { "m_flLiteralValue": -1 }
	// MPropertyFriendlyName = "use old code"
	bool m_bUseOldCode; // = true
};
