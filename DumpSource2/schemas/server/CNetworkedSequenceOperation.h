// MHasKV3TransferPolymorphicClassname
class CNetworkedSequenceOperation
{
	HSequence m_hSequence; // = -1
	float32 m_flPrevCycle;
	float32 m_flCycle;
	CNetworkedQuantizedFloat m_flWeight; // = 1
	bool m_bSequenceChangeNetworked;
	bool m_bDiscontinuity;
	float32 m_flPrevCycleFromDiscontinuity;
	float32 m_flPrevCycleForAnimEventDetection;
};
