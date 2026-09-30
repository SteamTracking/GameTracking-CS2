class CNmTarget
{
	CTransform m_transform; // = [ 0, 0, 0, 1, 0, 0, 0, 1 ]
	CGlobalSymbol m_boneID;
	bool m_bIsBoneTarget;
	bool m_bIsUsingBoneSpaceOffsets; // = true
	bool m_bHasOffsets;
	bool m_bIsSet;
};
