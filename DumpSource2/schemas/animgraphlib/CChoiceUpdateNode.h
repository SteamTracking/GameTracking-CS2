// MHasKV3TransferPolymorphicClassname
class CChoiceUpdateNode : public CAnimUpdateNodeBase
{
	CUtlVector< CAnimUpdateNodeRef > m_children;
	CUtlVector< float32 > m_weights;
	CUtlVector< float32 > m_blendTimes;
	ChoiceMethod m_choiceMethod; // = "WeightedRandom"
	ChoiceChangeMethod m_choiceChangeMethod; // = "OnReset"
	ChoiceBlendMethod m_blendMethod; // = "SingleBlendTime"
	float32 m_blendTime;
	bool m_bCrossFade;
	bool m_bResetChosen;
	bool m_bDontResetSameSelection;
};
