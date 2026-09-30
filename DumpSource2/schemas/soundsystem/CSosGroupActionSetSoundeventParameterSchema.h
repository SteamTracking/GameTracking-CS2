// MPropertyFriendlyName = "Set Sound Event Parameter"
// MHasKV3TransferPolymorphicClassname
class CSosGroupActionSetSoundeventParameterSchema : public CSosGroupActionSchema
{
	int32 m_nMaxCount; // = -1
	float32 m_flMinValue;
	float32 m_flMaxValue; // = 1
	// MPropertyFriendlyName = "Parameter Name"
	CUtlString m_opvarName; // = "None"
	SosActionSetParamSortType_t m_nSortType; // = "SOS_SETPARAM_SORTTYPE_LOWEST"
};
