class BlendItem_t
{
	CUtlVector< TagSpan_t > m_tags;
	CAnimUpdateNodeRef m_pChild; // = { "m_nodeIndex": -1 }
	HSequence m_hSequence; // = -1
	Vector2D m_vPos;
	float32 m_flDuration;
	bool m_bUseCustomDuration;
};
