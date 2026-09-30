// MHasKV3TransferPolymorphicClassname
class CNmClipDocEvent_MaterialAttribute : public CNmClipDocEvent
{
	CNmEventTargetEntity_t m_target; // = "Self"
	CUtlString m_attributeName;
	CPiecewiseCurve m_x;
	CPiecewiseCurve m_y;
	CPiecewiseCurve m_z;
	CPiecewiseCurve m_w;
};
