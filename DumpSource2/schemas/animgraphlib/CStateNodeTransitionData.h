class CStateNodeTransitionData
{
	CBlendCurve m_curve; // = { "m_flControlPoint1": 0, "m_flControlPoint2": 1 }
	CAnimValue< float32 > m_blendDuration; // = { "m_constValue": 0, "m_hParam": { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" } }
	CAnimValue< float32 > m_resetCycleValue; // = { "m_constValue": 0, "m_hParam": { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" } }
	bitfield:1 m_bReset;
	bitfield:3 m_resetCycleOption;
};
