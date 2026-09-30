class PhysObjectHeader_t
{
	PhysInterfaceId_t type;
	CHandle< C_BaseEntity > hEntity;
	CUtlSymbolLarge fieldName;
	bool bSaveObject;
	CUtlSymbolLarge modelName;
	AABB_t bbox;
	physics_save_sphere_t sphere;
	int32 iCollide;
};
