// MVDataRoot
// MVDataOverlayType = 1
class CNmPreviewArchetype
{
	// MPropertyAttributeEditor = "AssetBrowse( vnmskel, *requiredoubleclick )"
	// MPropertyGroupName = "+Primary Skeleton"
	// MPropertyAutoExpandSelf
	CUtlString m_primarySkeleton;
	// MPropertyAttributeEditor = "AssetBrowse( vmdl, *requiredoubleclick )"
	// MPropertyGroupName = "+Primary Skeleton"
	// MPropertyAutoExpandSelf
	CUtlString m_previewModel;
	// MPropertyGroupName = "+Primary Skeleton"
	// MPropertyAutoExpandSelf
	CUtlString m_bodyPartChoiceName;
	// MPropertyGroupName = "+Secondary Skeletons"
	// MPropertyAutoExpandSelf
	CUtlVector< CNmPreviewArchetype::SecondarySkeleton_t > m_secondarySkeletonSettings;
};
