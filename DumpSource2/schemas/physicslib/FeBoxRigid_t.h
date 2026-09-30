class FeBoxRigid_t
{
	CTransform tmFrame2; // = [ 0, 0, 0, 1, 0, 0, 0, 1 ]
	uint16 nNode;
	uint16 nCollisionMask; // = 65535
	Vector vSize;
	uint16 nVertexMapIndex; // = 65535
	uint16 nFlags;
};
