class VPhysXJoint_t
{
	uint16 m_nType;
	uint16 m_nBody1;
	uint16 m_nBody2;
	uint16 m_nFlags;
	CTransform m_Frame1; // = [ 0, 0, 0, 1, 0, 0, 0, 1 ]
	CTransform m_Frame2; // = [ 0, 0, 0, 1, 0, 0, 0, 1 ]
	bool m_bEnableCollision;
	bool m_bIsLinearConstraintDisabled;
	bool m_bIsAngularConstraintDisabled;
	bool m_bEnableLinearLimit;
	VPhysXRange_t m_LinearLimit;
	bool m_bEnableLinearMotor;
	Vector m_vLinearTargetVelocity;
	float32 m_flMaxForce;
	bool m_bEnableSwingLimit;
	VPhysXRange_t m_SwingLimit;
	bool m_bEnableTwistLimit;
	VPhysXRange_t m_TwistLimit;
	bool m_bEnableAngularMotor;
	Vector m_vAngularTargetVelocity;
	float32 m_flMaxTorque;
	float32 m_flLinearFrequency;
	float32 m_flLinearDampingRatio;
	float32 m_flAngularFrequency;
	float32 m_flAngularDampingRatio;
	float32 m_flFriction;
	float32 m_flElasticity;
	float32 m_flElasticDamping;
	float32 m_flPlasticity;
	CUtlString m_Tag;
};
