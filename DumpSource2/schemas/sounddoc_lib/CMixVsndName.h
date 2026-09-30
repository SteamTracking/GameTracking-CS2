// MPropertyFriendlyName = "VMix VSND Input Node"
// MPropertyDescription = "Create a variable that can contain the name of a vsnd file that can be modified by code/operator stack.  This can be used to select the IR for a convolution node."
// MHasKV3TransferPolymorphicClassname
class CMixVsndName : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Default Value"
	// MPropertyAttributeEditor = "AssetBrowse( vsnd )"
	CUtlString m_defaultValue; // = "sounds/ir/default.vsnd"
};
