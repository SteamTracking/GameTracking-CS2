class CDecalInstance
{
	CGlobalSymbol m_sDecalGroup;
	CStrongHandle< InfoForResourceTypeIMaterial2 > m_hMaterial;
	CUtlStringToken m_sSequenceName;
	CHandle< C_BaseEntity > m_hEntity;
	int32 m_nBoneIndex; // = -1
	int32 m_nTriangleIndex; // = -1
	Vector m_vPositionLS;
	Vector m_vPositionOS;
	Vector m_vNormalLS;
	Vector m_vNormalOS;
	Vector m_vSAxisLS; // = [ 340282346638528859811704183484516925440, 340282346638528859811704183484516925440, 340282346638528859811704183484516925440 ]
	DecalFlags_t m_nFlags;
	Color m_Color;
	float32 m_flWidth;
	float32 m_flHeight;
	float32 m_flDepth;
	matrix3x4_t m_mTransform;
	matrix3x4_t m_mLocalToTriangle; // = [ 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0 ]
	float32 m_flAnimationScale;
	float32 m_flAnimationStartTime;
	GameTime_t m_flPlaceTime;
	float32 m_flFadeStartTime;
	float32 m_flFadeDuration;
	float32 m_flLightingOriginOffset;
	float32 m_flBoundingRadiusSqr;
	// MNotSaved
	int16 m_nSequenceIndex;
	// MNotSaved
	bool m_bIsAdjacent;
	bool m_bDoDecalLightmapping;
};
