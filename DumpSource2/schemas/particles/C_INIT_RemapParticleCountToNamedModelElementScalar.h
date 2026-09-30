// MHasKV3TransferPolymorphicClassname
class C_INIT_RemapParticleCountToNamedModelElementScalar : public C_INIT_RemapParticleCountToScalar
{
	CStrongHandle< InfoForResourceTypeCModel > m_hModel;
	// MPropertyFriendlyName = "output min name"
	CUtlString m_outputMinName;
	// MPropertyFriendlyName = "output max name"
	CUtlString m_outputMaxName;
	bool m_bModelFromRenderer;
};
