// MPropertyFriendlyName = "Limiter"
// MHasKV3TransferPolymorphicClassname
class CSosGroupActionLimitSchema : public CSosGroupActionSchema
{
	int32 m_nMaxCount; // = -1
	SosActionStopType_t m_nStopType; // = "SOS_STOPTYPE_NONE"
	SosActionLimitSortType_t m_nSortType; // = "SOS_LIMIT_SORTTYPE_HIGHEST"
	bool m_bStopImmediate;
	// MPropertyFriendlyName = "Count Stopped Events"
	bool m_bCountStopped; // = true
};
