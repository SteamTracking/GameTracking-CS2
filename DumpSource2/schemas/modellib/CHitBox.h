class CHitBox
{
	CUtlString m_name;
	CUtlString m_sSurfaceProperty;
	CUtlString m_sBoneName;
	Vector m_vMinBounds;
	Vector m_vMaxBounds;
	float32 m_flShapeRadius;
	uint32 m_nBoneNameHash;
	int32 m_nGroupId;
	uint8 m_nShapeType;
	bool m_bTranslationOnly;
	uint32 m_CRC;
	Color m_cRenderColor; // = [ 255, 255, 255 ]
	uint16 m_nHitBoxIndex;
};
