// MPropertyFriendlyName = "Timed Block Limiter"
// MHasKV3TransferPolymorphicClassname
class CSosGroupActionTimeBlockLimitSchema : public CSosGroupActionSchema
{
	int32 m_nMaxCount; // = -1
	float32 m_flMaxDuration;
};
