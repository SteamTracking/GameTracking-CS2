// MHasKV3TransferPolymorphicClassname
class C_OP_SetControlPointsToModelParticles : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "hitbox set"
	char[128] m_HitboxSetName; // = "default"
	// MPropertyFriendlyName = "attachment to follow"
	char[128] m_AttachmentName;
	// MPropertyFriendlyName = "First control point to set"
	int32 m_nFirstControlPoint;
	// MPropertyFriendlyName = "# of control points to set"
	int32 m_nNumControlPoints; // = 1
	// MPropertyFriendlyName = "first particle to copy"
	int32 m_nFirstSourcePoint;
	// MPropertyFriendlyName = "use skinning instead of hitboxes"
	bool m_bSkin;
	// MPropertyFriendlyName = "follow attachment"
	bool m_bAttachment;
};
