// MHasKV3TransferPolymorphicClassname
class C_OP_ModelCull : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "control point number"
	int32 m_nControlPointNumber;
	// MPropertyFriendlyName = "use only bounding box"
	bool m_bBoundBox;
	// MPropertyFriendlyName = "cull outside instead of inside"
	bool m_bCullOutside;
	// MPropertyFriendlyName = "use bones instead of hitboxes"
	bool m_bUseBones;
	// MPropertyFriendlyName = "hitbox set"
	char[128] m_HitboxSetName; // = "default"
};
