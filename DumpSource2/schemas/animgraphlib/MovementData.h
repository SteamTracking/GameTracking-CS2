class MovementData
{
	Vector m_goalWayPointPos;
	CAnimNetVar< Vector > m_vMoveDir; // = [ 1, 0, 0 ]
	CAnimNetVar< Vector > m_vAcceleration;
	CAnimNetVar< float32 > m_flCurrentMoveSpeed;
	CAnimNetVar< float32 > m_flTargetMoveSpeed;
	CAnimNetVar< float32 > m_flGoalDistance; // = -1
	CAnimNetVar< float32 > m_flBoundaryRadius; // = 100
	bool m_bGoalChanged;
	CAnimNetVar< bool > m_bHasPath;
	CAnimNetVar< float32 > m_flFacingHeading;
	Vector m_vManualFacingDirection; // = [ 1, 0, 0 ]
	VectorWS m_vManualFacingTarget;
	CAnimNetVar< uint8 > m_nFacingMode;
	CAnimNetVar< bool > m_bForceFacing;
	CAnimNetVar< int32 > m_nActiveMotorIndex; // = -1
	CAnimNetVar< bool > m_bOnGround; // = true
	CAnimNetVar< Vector > m_vFacingPosition;
	Vector m_vPrevFacingPosition;
};
