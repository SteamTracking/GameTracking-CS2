class CSprayedDataSettingsBlock
{
	float32 m_flMinDensity; // = 1
	float32 m_flMaxDensity; // = 1
	float32 m_flMinScale; // = 0.5
	float32 m_flMaxScale; // = 1
	QAngle m_vMinAngle;
	QAngle m_vMaxAngle; // = [ 0, 360, 0 ]
	Vector m_vMinColor; // = [ 1, 1, 1 ]
	Vector m_vMaxColor; // = [ 1, 1, 1 ]
	float32 m_flSpacingMul; // = 1
	float32 m_flSlopeThreshold; // = 100000
	Vector m_vMasterDirection; // = [ 0, 0, 1 ]
	float32 m_flMasterDirectionInfluence;
	bool m_bEnabled; // = true
};
