// MHasKV3TransferPolymorphicClassname
class C_OP_RemapDistanceToLineSegmentBase : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "control point 0"
	int32 m_nCP0;
	// MPropertyFriendlyName = "control point 1"
	int32 m_nCP1;
	// MPropertyFriendlyName = "min distance value"
	float32 m_flMinInputValue;
	// MPropertyFriendlyName = "max distance value"
	float32 m_flMaxInputValue;
	// MPropertyFriendlyName = "use distance to an infinite line instead of a finite line segment"
	bool m_bInfiniteLine;
};
