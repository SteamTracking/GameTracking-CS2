// MHasKV3TransferPolymorphicClassname
class C_INIT_RandomModelSequence : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "activity"
	// MPropertySuppressExpr = "mod != dota"
	char[256] m_ActivityName;
	// MPropertyFriendlyName = "sequence"
	// MPropertySuppressExpr = "mod == dota"
	char[256] m_SequenceName;
	// MPropertyFriendlyName = "model"
	CStrongHandle< InfoForResourceTypeCModel > m_hModel;
};
