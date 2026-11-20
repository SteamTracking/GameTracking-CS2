class CPulseCell_LerpCameraSettings::CursorState_t : public CPulseCell_BaseLerp::CursorState_t
{
	CHandle< CPointCamera > m_hCamera;
	PointCameraSettings_t m_OverlaidStart;
	PointCameraSettings_t m_OverlaidEnd;
};
