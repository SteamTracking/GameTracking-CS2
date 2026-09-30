class VPhysXAggregateData_t
{
	uint16 m_nFlags;
	uint16 m_nRefCounter;
	bool m_bCompoundsPacked;
	CUtlVector< uint32 > m_bonesHash;
	CUtlVector< CUtlString > m_boneNames;
	CUtlVector< uint16 > m_indexNames;
	CUtlVector< uint16 > m_indexHash;
	CUtlVector< matrix3x4a_t > m_bindPose;
	CUtlVector< VPhysXBodyPart_t > m_parts;
	CUtlVector< PhysShapeMarkup_t > m_shapeMarkups;
	CUtlVector< VPhysXConstraint2_t > m_constraints2;
	CUtlVector< VPhysXJoint_t > m_joints;
	PhysFeModelDesc_t* m_pFeModel;
	CUtlVector< uint16 > m_boneParents;
	CUtlVector< uint32 > m_surfacePropertyHashes;
	CUtlVector< VPhysXCollisionAttributes_t > m_collisionAttributes;
	CUtlVector< CUtlString > m_debugPartNames;
	CUtlString m_embeddedKeyvalues;
};
