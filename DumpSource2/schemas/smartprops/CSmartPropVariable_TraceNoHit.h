// MPropertyFriendlyName = "Trace Miss Behavior"
// MPropertyDescription = "Specified what to do when a trace does not hit a surface."
// MVDataClassGroup = "Enumerator Types"
// MHasKV3TransferPolymorphicClassname
class CSmartPropVariable_TraceNoHit : public CSmartPropVariable
{
	TraceNoHitResult_t m_DefaultValue; // = "NOTHING"
};
