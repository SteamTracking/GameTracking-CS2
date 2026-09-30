class CDebugSnapshotData_t
{
	CUtlString m_text;
	uint32 m_dataType;
	uint32 m_userFlags;
	uint32 m_userData;
	VectorWS m_userVector;
	CTransformWS m_userTransform;
	CGenericShapeProxy m_userShape;
	Color m_drawColor;
	CUtlVector< CDebugDrawHistoryData* > m_vecDebugOverlayData;
	DebugSnapshotBaseStructuredData_t* m_pStructuredData;
	CHandle< C_BaseEntity > m_hEntity;
	CUtlString m_sEntityName;
	CEntityIndex m_nEntityIndex;
	CUtlLeanVector< CDebugSnapshotData_t > m_children;
};
