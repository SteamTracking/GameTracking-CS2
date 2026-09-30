// MHasKV3TransferPolymorphicClassname
class CNmMaterialAttributeEvent : public CNmEvent
{
	CNmEventTargetEntity_t m_target; // = "Self"
	CUtlString m_attributeName;
	CUtlStringToken m_attributeNameToken;
	CPiecewiseCurve m_x;
	CPiecewiseCurve m_y;
	CPiecewiseCurve m_z;
	CPiecewiseCurve m_w;
};
