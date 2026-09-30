// MHasKV3TransferPolymorphicClassname
class C_OP_TeleportBeam : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "Position Control Point"
	int32 m_nCPPosition;
	// MPropertyFriendlyName = "Velocity Control Point"
	int32 m_nCPVelocity; // = 1
	// MPropertyFriendlyName = "Misc Control Point"
	int32 m_nCPMisc; // = 2
	// MPropertyFriendlyName = "Color Control Point"
	int32 m_nCPColor; // = 3
	// MPropertyFriendlyName = "Invalid Color Control Point"
	int32 m_nCPInvalidColor; // = 4
	// MPropertyFriendlyName = "Extra Arc Data Point"
	int32 m_nCPExtraArcData; // = 5
	// MPropertyFriendlyName = "Gravity"
	Vector m_vGravity; // = [ 0, 0, -800 ]
	// MPropertyFriendlyName = "Arc Duration Maximum"
	float32 m_flArcMaxDuration; // = 3
	// MPropertyFriendlyName = "Segment Break"
	float32 m_flSegmentBreak; // = 0.025
	// MPropertyFriendlyName = "Arc Speed"
	float32 m_flArcSpeed; // = 0.2
	// MPropertyFriendlyName = "Alpha"
	float32 m_flAlpha; // = 0.5
};
