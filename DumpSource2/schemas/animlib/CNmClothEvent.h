// MHasKV3TransferPolymorphicClassname
class CNmClothEvent : public CNmEvent
{
	CNmClothEvent::Type_t m_type; // = "Stiffen"
	float32 m_flStiffness; // = 1
	float32 m_flSpeedIn; // = 10
	float32 m_flSpeedOut; // = 10
	float32 m_flLengthSeconds; // = 1
	CUtlString m_vertexSetName;
	CUtlString m_effectName;
};
