class ClutterSceneObject_t
{
	AABB_t m_Bounds;
	ObjectTypeFlags_t m_flags; // = "OBJECT_TYPE_NONE"
	int16 m_nLayer;
	CUtlVector< Vector > m_instancePositions;
	CUtlVector< float32 > m_instanceScales;
	CUtlVector< Color > m_instanceTintSrgb;
	CUtlVector< ClutterTile_t > m_tiles;
	CStrongHandle< InfoForResourceTypeCModel > m_renderableModel;
	CUtlStringToken m_materialGroup;
	float32 m_flBeginCullSize; // = 0.02
	float32 m_flEndCullSize; // = 0.0125
};
