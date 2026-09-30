class CInfoChoreoAnchorPosition
{
	Vector m_vOriginLS;
	Quaternion m_qAnglesLS;
	Vector m_vExtentsMin; // = [ 0, -20, 0 ]
	Vector m_vExtentsMax; // = [ 0, 20, 0 ]
	float32 m_flRadius; // = 12
	bool m_bOnlyWarpPosition;
	CHandle< CBaseEntity > m_hParent;
	CInfoChoreoLocatorShapeType_t m_nShapeType; // = "POINT"
};
