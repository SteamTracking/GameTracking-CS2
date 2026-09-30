class FeSDFRigid_t
{
	Vector vLocalMin;
	Vector vLocalMax;
	float32 flBounciness;
	uint16 nNode;
	uint16 nCollisionMask; // = 65535
	uint16 nVertexMapIndex; // = 65535
	uint16 nFlags;
	CUtlVector< float32 > m_Distances;
	int32 m_nWidth; // = 8
	int32 m_nHeight; // = 8
	int32 m_nDepth; // = 8
};
