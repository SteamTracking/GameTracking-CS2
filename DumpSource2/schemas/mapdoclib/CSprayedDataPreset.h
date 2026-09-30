class CSprayedDataPreset
{
	int32 m_nCounterMin; // = 4
	int32 m_nCounterMax; // = 4
	float32 m_flSpacing; // = 64
	float32 m_flRadius; // = 128
	float32 m_flEraseAmount; // = 1
	bool m_bConstantDensity; // = true
	bool m_bOnlyHitMeshes;
	bool m_bRadialFalloff; // = true
	CUtlVector< CSprayedDataPresetElement > m_elements;
};
