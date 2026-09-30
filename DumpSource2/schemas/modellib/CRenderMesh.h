// MHasKV3TransferPolymorphicClassname
class CRenderMesh
{
	CUtlLeanVectorFixedGrowable< CSceneObjectData, 1 > m_sceneObjects;
	CUtlLeanVector< CBaseConstraint* > m_constraints;
	CRenderSkeleton m_skeleton; // = { "m_boneParents": [  ], "m_bones": [  ], "m_nBoneWeightCount": 4 }
	bool m_bUseUV2ForCharting;
	bool m_bEmbeddedMapMesh;
	DynamicMeshDeformParams_t m_meshDeformParams;
	CRenderGroom* m_pGroomData;
};
