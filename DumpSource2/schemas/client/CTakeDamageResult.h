class CTakeDamageResult
{
	// MKV3TransferSaveOpsForField = "GetTakeDamageConstPtrSaveRestoreOps"
	CTakeDamageInfo* m_pOriginatingInfo; // = { "_class": "CTakeDamageInfo", "m_flFriendlyFireDamageReductionRatio": 1, "m_iHitGroupId": "HITGROUP_INVALID" }
	CUtlLeanVector< DestructiblePartDamageRequest_t > m_DestructibleHitGroupRequests;
	int32 m_nHealthLost;
	int32 m_nHealthBefore;
	float32 m_flDamageDealt;
	float32 m_flPreModifiedDamage;
	VectorWS m_vDamagePosition;
	int32 m_nTotalledHealthLost;
	float32 m_flTotalledDamageDealt;
	float32 m_flTotalledPreModifiedDamage;
	float32 m_flNewDamageAccumulatorValue;
	TakeDamageFlags_t m_nDamageFlags;
	bool m_bWasDamageSuppressed;
	bool m_bSuppressFlinch;
	HitGroup_t m_nOverrideFlinchHitGroup; // = "HITGROUP_INVALID"
};
