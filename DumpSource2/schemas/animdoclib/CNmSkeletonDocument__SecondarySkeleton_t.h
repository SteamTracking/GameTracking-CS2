// MPropertyAutoExpandSelf
class CNmSkeletonDocument::SecondarySkeleton_t
{
	// MPropertyAttributeEditor = "AssetBrowse( vnmskel, *requiredoubleclick )"
	CUtlString m_skeleton;
	// MPropertyDescription = "The bone that we expect this skeleton to be attached to in the parent"
	CGlobalSymbol m_attachToBoneID;
};
