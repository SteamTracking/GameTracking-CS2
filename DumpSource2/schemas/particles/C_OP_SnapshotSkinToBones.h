// MHasKV3TransferPolymorphicClassname
class C_OP_SnapshotSkinToBones : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "rotate normals"
	bool m_bTransformNormals;
	// MPropertyFriendlyName = "scale radii"
	bool m_bTransformRadii;
	// MPropertyFriendlyName = "control point number"
	int32 m_nControlPointNumber;
	// MPropertyFriendlyName = "lifetime fade start"
	float32 m_flLifeTimeFadeStart; // = 1
	// MPropertyFriendlyName = "lifetime fade end"
	float32 m_flLifeTimeFadeEnd; // = 1
	// MPropertyFriendlyName = "instant jump threshold"
	float32 m_flJumpThreshold; // = 100
	// MPropertyFriendlyName = "previous position scale"
	float32 m_flPrevPosScale; // = 1
};
