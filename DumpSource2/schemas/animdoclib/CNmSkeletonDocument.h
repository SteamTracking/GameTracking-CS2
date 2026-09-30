// MHasKV3TransferPolymorphicClassname
class CNmSkeletonDocument : public CNmAnimDocument
{
	// MPropertyAttributeEditor = "ModelDocAssetBrowse( dmx, fbx, smd, *requiredoubleclick, *ShowRelatedFile )"
	CUtlString m_sourceFilename;
	CUtlString m_rootBoneName; // = "root_motion"
	float32 m_flGlobalScale; // = 1
	bool m_bIsAttachableProp;
	bool m_bIsCS_HACK;
	CUtlVector< CNmSkeletonDocument::ContactConfig_t > m_contactConfigs;
	// MPropertyFriendlyName = "Expected secondary skeletons"
	// MPropertyAutoExpandSelf
	CUtlVector< CNmSkeletonDocument::SecondarySkeleton_t > m_secondarySkeletons;
	// MPropertyDescription = "The set of bones that need to be converted at import to match the S2 coordinate system (Z-up, X-forward)"
	CUtlVector< CGlobalSymbol > m_gameplayRelevantBones;
	// MPropertySuppressField
	CUtlVector< CGlobalSymbol > m_highLODBones;
	// MPropertySuppressField
	CUtlVector< NmBoneMaskSetDefinition_t > m_boneMaskSetDefinitions;
	// MPropertySuppressField
	CUtlVector< CNmFloatChannelSet_t > m_floatChannelSets;
	// MPropertyGroupName = "+Preview"
	// MPropertyAttributeEditor = "AssetBrowse( vmdl, *requiredoubleclick )"
	CUtlString m_previewModelName;
};
