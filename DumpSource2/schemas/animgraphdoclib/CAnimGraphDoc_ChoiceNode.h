// MPropertyFriendlyName = "Choice"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_ChoiceNode : public CAnimGraphDoc_Node
{
	// MPropertyFriendlyName = "Options"
	// MPropertyAutoExpandSelf
	CUtlVector< CChoiceNodeChild > m_children;
	// MPropertySuppressField
	int32 m_seed;
	// MPropertyFriendlyName = "Method"
	ChoiceMethod m_choiceMethod; // = "WeightedRandom"
	// MPropertyFriendlyName = "Change Selection"
	ChoiceChangeMethod m_choiceChangeMethod; // = "OnReset"
	// MPropertyGroupName = "Blending"
	// MPropertyFriendlyName = "Blend Method"
	// MPropertyAutoRebuildOnChange
	ChoiceBlendMethod m_blendMethod; // = "SingleBlendTime"
	// MPropertyGroupName = "Blending"
	// MPropertyFriendlyName = "Blend Duration"
	// MPropertyAttrStateCallback
	float32 m_blendTime; // = 0.2
	// MPropertyGroupName = "Blending"
	// MPropertyFriendlyName = "Cross Fade"
	bool m_bCrossFade;
	// MPropertyFriendlyName = "Reset On Selection"
	// MPropertyAutoRebuildOnChange
	bool m_bResetChosen; // = true
	// MPropertyFriendlyName = "Don't Reset Same Selection"
	// MPropertyAttrStateCallback
	bool m_bDontResetSameSelection;
};
