// MHasKV3TransferPolymorphicClassname
class CCopyRecipientFilter
{
	int32 m_Flags;
	CUtlVector< CPlayerSlot > m_Recipients;
	CPlayerSlot m_slotPlayerExcludedDueToPrediction; // = -1
};
