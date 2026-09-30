class MaterialOverride_t : public BaseSceneObjectOverride_t
{
	uint32 m_nSubSceneObject;
	uint32 m_nDrawCallIndex;
	CStrongHandle< InfoForResourceTypeIMaterial2 > m_pMaterial;
	Vector m_vLinearTintColor; // = [ 1, 1, 1 ]
};
