class RnBodyDesc_t
{
	CUtlString m_sDebugName;
	VectorWS m_vPosition;
	QuaternionStorage m_qOrientation; // = [ 0, 0, 0, 1 ]
	Vector m_vLinearVelocity;
	Vector m_vAngularVelocity;
	Vector m_vLocalMassCenter;
	Vector[3] m_LocalInertiaInv;
	float32 m_flMassInv;
	float32 m_flGameMass;
	float32 m_flMassScaleInv; // = 1
	float32 m_flInertiaScaleInv; // = 1
	float32 m_flLinearDamping;
	float32 m_flAngularDamping;
	float32 m_flLinearDragScale; // = 1
	float32 m_flAngularDragScale; // = 1
	float32 m_flLinearFluidDragScale; // = 1
	float32 m_flAngularFluidDragScale; // = 1
	Vector m_vLastAwakeForceAccum;
	Vector m_vLastAwakeTorqueAccum;
	float32 m_flBuoyancyScale; // = 1
	float32 m_flGravityScale; // = 1
	float32 m_flTimeScale; // = 1
	int32 m_nBodyType;
	uint32 m_nGameIndex;
	uint32 m_nGameFlags;
	int8 m_nMinVelocityIterations; // = 1
	int8 m_nMinPositionIterations;
	int8 m_nMassPriority;
	bool m_bEnabled; // = true
	bool m_bSleeping;
	bool m_bIsContinuousEnabled; // = true
	bool m_bDragEnabled; // = true
	Vector m_vGravity;
	bool m_bSpeculativeEnabled; // = true
	bool m_bHasShadowController;
	DynamicContinuousContactBehavior_t m_nDynamicContinuousContactBehavior; // = "DYNAMIC_CONTINUOUS_ALLOW_IF_REQUESTED_BY_OTHER_BODY"
};
