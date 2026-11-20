class CStateNodeTransitionData
{
	CBlendCurve m_curve;
	CAnimValue< float32 > m_blendDuration; // = { "m_hParam": { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" } }
	CAnimValue< float32 > m_resetCycleValue; // = { "m_hParam": { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" } }
	bitfield:1 m_bReset;
	bitfield:3 m_resetCycleOption;
};
