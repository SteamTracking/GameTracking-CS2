// MHasKV3TransferPolymorphicClassname
class CNmGraphDocRootMotionOverrideNode : public CNmGraphDocFlowNode
{
	float32 m_flMaxLinearVelocity; // = -1
	float32 m_flMaxAngularVelocityDegrees; // = -1
	bool m_bOverrideMoveDirX; // = true
	bool m_bOverrideMoveDirY; // = true
	bool m_bOverrideMoveDirZ; // = true
	bool m_bAllowPitchForFacing;
	bool m_bListenForRootMotionEvents;
};
