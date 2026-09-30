// MHasKV3TransferPolymorphicClassname
class CNmClipDocument : public CNmAnimDocument
{
	// MPropertyAttributeEditor = "ModelDocAssetBrowse( dmx, fbx, smd, *requiredoubleclick, *ShowRelatedFile )"
	CUtlString m_sourceFilename;
	// MPropertyAttributeEditor = "AssetBrowse( vnmskel, *requiredoubleclick )"
	CUtlString m_animationSkeletonName;
	// MPropertyAttributeEditor = "AssetBrowse( vnmskel, *requiredoubleclick )"
	// MPropertyAutoExpandSelf
	CUtlVector< CUtlString > m_secondaryAnimationSkeletonNames;
	// MPropertySuppressField
	CUtlLeanVector< CNmClipDocEventTrack > m_eventTracks;
	// MPropertyGroupName = "+Import Options"
	// MPropertyDescription = "Specify the import start frame (0 or a negative value means use the first frame in the authored animation)"
	int32 m_nStartFrame; // = -1
	// MPropertyGroupName = "+Import Options"
	// MPropertyDescription = "Specify the import end frame (0 or a negative value means use the last frame in the authored animation)"
	int32 m_nEndFrame; // = -1
	// MPropertyGroupName = "+Import Options"
	// MPropertyDescription = "Override the final duration of this clip in seconds (0 or a negative value means use the authored duration)"
	float32 m_flDurationOverrideSeconds; // = -1
	// MPropertyGroupName = "+Additive"
	CNmClipDocument::AdditiveType_t m_additiveType; // = "None"
	// MPropertyGroupName = "+Additive"
	// MPropertyAttributeEditor = "AssetBrowse( dmx, fbx, *requiredoubleclick )"
	// MPropertyDescription = "The source file to use as the base of the additive"
	// MPropertyAttrStateCallback
	CUtlString m_additiveBaseFilename;
	// MPropertyGroupName = "+Additive"
	// MPropertyDescription = "The frame to use when generating an additive, if you are generating relative to another animation and this is set to -1, we will extract each frame from it's corresponding frame in the base anim"
	// MPropertyAttrStateCallback
	CNmClipDocument::AdditiveBaseFrame_t m_additiveBaseFrame; // = "FirstFrame"
	// MPropertyGroupName = "+Additive"
	// MPropertyDescription = "The frame to use when generating an additive, only valid for 'RelativeToFrame' and 'RelativeToAnimationFrame' "
	// MPropertyAttrStateCallback
	int32 m_nAdditiveBaseFrameIdx; // = -1
	// MPropertyGroupName = "+Additive"
	// MPropertyDescription = "Should we calculate the additives for the secondary weapons from their reference pose or try to look up a pose in the specified animation"
	// MPropertyAttrStateCallback
	bool m_bUseReferencePoseForSecondaryAnimAdditives;
	// MPropertyGroupName = "Advanced"
	// MPropertyAutoExpandSelf
	// MPropertyDescription = "List the set of bones that need to be sampled in model space for sub-frames. Warning! This can be REALLY expensive so be careful with this!"
	CUtlVector< CUtlString > m_bonesToSampleInModelSpace;
};
