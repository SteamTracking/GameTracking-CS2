// MVDataRoot
// MVDataNodeType = 1
// MPropertyPolymorphicClass
// MVDataFileExtension = "vsnd"
// MVDataSingleton
// MPropertyFriendlyName = "VSND Container"
// MPropertyDescription = "Voice Container Base"
// MHasKV3TransferPolymorphicClassname
class CVoiceContainerBase
{
	// MPropertySuppressField
	CVSound m_vSound;
	// MPropertySuppressExpr = "true"
	CVoiceContainerAnalysisBase* m_pEnvelopeAnalyzer;
};
