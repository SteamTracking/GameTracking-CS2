class FeVertexMapDesc_t
{
	CUtlString sName;
	uint32 nNameHash;
	uint32 nColor;
	uint32 nFlags;
	uint16 nVertexBase;
	uint16 nVertexCount;
	uint32 nMapOffset;
	uint32 nNodeListOffset;
	Vector vCenterOfMass;
	float32 flVolumetricSolveStrength;
	int16 nScaleSourceNode; // = -1
	uint16 nNodeListCount;
};
