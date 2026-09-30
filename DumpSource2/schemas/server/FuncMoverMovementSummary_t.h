class FuncMoverMovementSummary_t
{
	float32 flStartT;
	float32 flEndT;
	int32 nStartNodeIndex;
	int32 nStopNodeIndex;
	int32 nMovementMode;
	FuncMoverMovementSummaryFlags_t nFlags;
	GameTick_t nTick;
	CHandle< CPathMover > hPathMover;
};
