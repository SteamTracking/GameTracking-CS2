class CPulseCell_LerpCameraSettings::CursorState_t : public CPulseCell_BaseLerp::CursorState_t
{
	CHandle< CPointCamera > m_hCamera;
	PointCameraSettings_t m_OverlaidStart; // = { "m_flFarBlurryDistance": -1, "m_flFarCrispDistance": -1, "m_flNearBlurryDistance": -1, "m_flNearCrispDistance": -1 }
	PointCameraSettings_t m_OverlaidEnd; // = { "m_flFarBlurryDistance": -1, "m_flFarCrispDistance": -1, "m_flNearBlurryDistance": -1, "m_flNearCrispDistance": -1 }
};
