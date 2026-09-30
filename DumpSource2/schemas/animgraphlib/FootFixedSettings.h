class FootFixedSettings
{
	TraceSettings_t m_traceSettings; // = { "m_flTraceHeight": 40, "m_flTraceRadius": 4 }
	VectorAligned m_vFootBaseBindPosePositionMS;
	float32 m_flFootBaseLength;
	float32 m_flMaxRotationLeft; // = 90
	float32 m_flMaxRotationRight; // = 90
	int32 m_footstepLandedTagIndex; // = -1
	bool m_bEnableTracing; // = true
	float32 m_flTraceAngleBlend;
	int32 m_nDisableTagIndex; // = -1
	int32 m_nFootIndex; // = -1
};
