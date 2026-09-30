class CAnimAttachment
{
	Quaternion[3] m_influenceRotations;
	VectorAligned[3] m_influenceOffsets;
	int32[3] m_influenceIndices;
	float32[3] m_influenceWeights;
	uint8 m_numInfluences;
};
