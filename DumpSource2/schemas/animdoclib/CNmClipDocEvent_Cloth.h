// MHasKV3TransferPolymorphicClassname
class CNmClipDocEvent_Cloth : public CNmClipDocEvent
{
	// MPropertyAutoRebuildOnChange
	CNmClothEvent::Type_t m_type; // = "Stiffen"
	// MPropertyAttrStateCallback
	float32 m_flStiffness; // = 1
	// MPropertyAttrStateCallback
	float32 m_flSpeedIn; // = 10
	// MPropertyAttrStateCallback
	float32 m_flSpeedOut; // = 10
	// MPropertyAttrStateCallback
	float32 m_flLengthSeconds; // = 1
	// MPropertyAttrStateCallback
	CUtlString m_vertexSetName;
	// MPropertyAttrStateCallback
	CUtlString m_effectName;
};
