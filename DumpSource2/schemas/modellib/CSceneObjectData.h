class CSceneObjectData
{
	Vector m_vMinBounds; // = [ 340282346638528859811704183484516925440, 340282346638528859811704183484516925440, 340282346638528859811704183484516925440 ]
	Vector m_vMaxBounds; // = [ -340282346638528859811704183484516925440, -340282346638528859811704183484516925440, -340282346638528859811704183484516925440 ]
	CUtlLeanVector< CMaterialDrawDescriptor > m_drawCalls;
	CUtlLeanVector< AABB_t > m_drawBounds;
	CUtlLeanVector< CMeshletDescriptor > m_meshlets;
	CUtlLeanVector< CSceneObjectData::RTProxyDrawDescriptor_t > m_rtProxyDrawCalls;
	Vector4D m_vTintColor;
};
