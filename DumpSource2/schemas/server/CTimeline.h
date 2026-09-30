// MNetworkNoBase
// MHasKV3TransferPolymorphicClassname
class CTimeline : public IntervalTimer
{
	float32[64] m_flValues;
	int32[64] m_nValueCounts;
	int32 m_nBucketCount;
	float32 m_flInterval;
	float32 m_flFinalValue;
	TimelineCompression_t m_nCompressionType;
	bool m_bStopped;
};
