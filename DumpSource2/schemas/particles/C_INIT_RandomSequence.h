// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_INIT_RandomSequence : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "sequence min"
	// MPropertyAttributeEditor = "SequencePicker( 1 )"
	int32 m_nSequenceMin;
	// MPropertyFriendlyName = "sequence max"
	// MPropertyAttributeEditor = "SequencePicker( 1 )"
	int32 m_nSequenceMax;
	// MPropertyFriendlyName = "shuffle"
	bool m_bShuffle;
	// MPropertyFriendlyName = "linear"
	bool m_bLinear;
	// MPropertyFriendlyName = "weighted list"
	CUtlVector< SequenceWeightedList_t > m_WeightedList;
};
