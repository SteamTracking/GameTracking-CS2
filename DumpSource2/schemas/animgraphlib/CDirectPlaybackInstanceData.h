class CDirectPlaybackInstanceData
{
	Vector m_vTargetPosition;
	float32 m_flTargetFacing;
	float32 m_flInterpEndTime; // = -1
	float32[4] m_weights;
	SequenceData[4] m_sequences; // = [ { "m_cycle": { "m_flCycleUnclamped": 0, "m_flCycleZeroTime": 0, "m_flCyclesPerSecond": 1, "m_flPrevCycleUnclamped": 0, "m_resetCount": 0 }, "m_hSequence": -1 }, { "m_cycle": { "m_flCycleUnclamped": 0, "m_flCycleZeroTime": 0, "m_flCyclesPerSecond": 1, "m_flPrevCycleUnclamped": 0, "m_resetCount": 0 }, "m_hSequence": -1 }, { "m_cycle": { "m_flCycleUnclamped": 0, "m_flCycleZeroTime": 0, "m_flCyclesPerSecond": 1, "m_flPrevCycleUnclamped": 0, "m_resetCount": 0 }, "m_hSequence": -1 }, { "m_cycle": { "m_flCycleUnclamped": 0, "m_flCycleZeroTime": 0, "m_flCyclesPerSecond": 1, "m_flPrevCycleUnclamped": 0, "m_resetCount": 0 }, "m_hSequence": -1 } ]
	uint32 m_currentSequenceIndex;
	CAnimNetVar< uint64 > m_currentSequenceData;
	float32 m_flFadeInTime; // = 0.2
	float32 m_flFadeOutTime; // = 0.2
	CAnimNetVar< float32 > m_flForcedCycle; // = -1
	bool m_bResetPending;
	CAnimNetVar< float32 > m_SequenceCycleZeroTime;
};
