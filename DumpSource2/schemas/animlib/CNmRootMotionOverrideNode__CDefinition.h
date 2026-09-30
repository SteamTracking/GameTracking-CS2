// MHasKV3TransferPolymorphicClassname
class CNmRootMotionOverrideNode::CDefinition : public CNmPassthroughNode::CDefinition
{
	int16 m_desiredMovingVelocityNodeIdx; // = -1
	int16 m_desiredFacingDirectionNodeIdx; // = -1
	int16 m_linearVelocityLimitNodeIdx; // = -1
	int16 m_angularVelocityLimitNodeIdx; // = -1
	int16 m_enabledNodeIdx; // = -1
	float32 m_maxLinearVelocity; // = -1
	float32 m_maxAngularVelocityRadians; // = -1
	CNmBitFlags m_overrideFlags; // = { "m_flags": 1 }
};
