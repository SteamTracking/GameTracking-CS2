// MHasKV3TransferPolymorphicClassname
class CNmGraphDocClipNode::CData : public CNmGraphDocVariationDataNode::CData
{
	// MPropertyAttributeEditor = "AssetBrowse( vnmclip, *requiredoubleclick )"
	CUtlString m_clip;
	// MPropertyAttributeRange = "0.01 5.0"
	float32 m_flSpeedMultiplier; // = 1
	int32 m_nStartSyncEventOffset;
};
