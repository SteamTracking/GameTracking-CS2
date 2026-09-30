// MPropertyFriendlyName = "VMix Control Array Input Node"
// MPropertyDescription = "Define a control array variable that can be set by code or an operator stack.  This can be used to control steamaudio pathing or steamaudio reverb for example."
// MHasKV3TransferPolymorphicClassname
class CMixControlInputArray : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Input Data"
	// MPropertyAttributeRange = "-1 1"
	CUtlVector< float32 > m_vflData;
};
