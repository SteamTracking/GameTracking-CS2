class DynamicVolumeDef_t
{
	CHandle< CBaseEntity > m_source;
	CHandle< CBaseEntity > m_target;
	int32 m_nHullIdx; // = -1
	VectorWS m_vSourceAnchorPos;
	VectorWS m_vTargetAnchorPos;
	uint32 m_nAreaSrc; // = 4294967295
	uint32 m_nAreaDst; // = 4294967295
	bool m_bAttached;
};
