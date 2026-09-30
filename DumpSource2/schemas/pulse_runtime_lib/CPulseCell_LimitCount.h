// MPropertyFriendlyName = "Limit Count"
// MPropertyDescription = "Skip this node after the limit. Check Type does not apply, the limit will always be checked."
// MHasKV3TransferPolymorphicClassname
class CPulseCell_LimitCount : public CPulseCell_BaseRequirement
{
	// MPropertyFlattenIntoParentRow
	int32 m_nLimitCount; // = 1
};
