class CTakeDamageResult
{
	// MKV3TransferSaveOpsForField = "GetTakeDamageConstPtrSaveRestoreOps"
	CTakeDamageInfo* m_pOriginatingInfo; // = { "_class": "CTakeDamageInfo", "m_DestructibleHitGroupRequests": [  ], "m_bShouldBleed": false, "m_bShouldSpark": false, "m_bStoppedBullet": false, "m_bitsDamageType": "", "m_flDamage": 0, "m_flFriendlyFireDamageReductionRatio": 1, "m_flOriginalDamage": 0, "m_flTotalledDamage": 0, "m_hAbility": null, "m_hAttacker": null, "m_hInflictor": null, "m_iAmmoType": "", "m_iDamageCustom": 0, "m_iHitGroupId": "HITGROUP_INVALID", "m_nDamageFlags": "", "m_nNumObjectsPenetrated": 0, "m_vecDamageDirection": [ 0, 0, 0 ], "m_vecDamageForce": [ 0, 0, 0 ], "m_vecDamagePosition": null, "m_vecReportedPosition": null }
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
