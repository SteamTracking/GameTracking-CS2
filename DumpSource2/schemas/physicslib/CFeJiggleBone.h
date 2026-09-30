class CFeJiggleBone
{
	uint32 m_nFlags;
	float32 m_flLength; // = 1
	float32 m_flTipMass;
	float32 m_flYawStiffness;
	float32 m_flYawDamping;
	float32 m_flPitchStiffness;
	float32 m_flPitchDamping;
	float32 m_flAlongStiffness;
	float32 m_flAlongDamping;
	float32 m_flAngleLimit;
	float32 m_flMinYaw;
	float32 m_flMaxYaw;
	float32 m_flYawFriction;
	float32 m_flYawBounce;
	float32 m_flMinPitch;
	float32 m_flMaxPitch;
	float32 m_flPitchFriction;
	float32 m_flPitchBounce;
	float32 m_flBaseMass;
	float32 m_flBaseStiffness;
	float32 m_flBaseDamping;
	float32 m_flBaseMinLeft;
	float32 m_flBaseMaxLeft;
	float32 m_flBaseLeftFriction;
	float32 m_flBaseMinUp;
	float32 m_flBaseMaxUp;
	float32 m_flBaseUpFriction;
	float32 m_flBaseMinForward;
	float32 m_flBaseMaxForward;
	float32 m_flBaseForwardFriction;
	float32 m_flRadius0; // = 1
	float32 m_flRadius1; // = 1
	Vector m_vPoint0;
	Vector m_vPoint1; // = [ 10, 0, 0 ]
	uint16 m_nCollisionMask; // = 65535
};
