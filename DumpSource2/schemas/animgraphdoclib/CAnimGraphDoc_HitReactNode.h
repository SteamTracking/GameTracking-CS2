// MPropertyFriendlyName = "Procedural Hit Reacts"
// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_HitReactNode : public CAnimGraphDoc_Node
{
	// MPropertySuppressField
	CAnimGraphDoc_NodeConnection m_inputConnection;
	// MPropertyFriendlyName = "Minimum Delay Between Hits"
	float32 m_flMinDelayBetweenHits;
	// MPropertySuppressField
	CUtlString m_triggerParamName;
	// MPropertySuppressField
	CUtlString m_hitBoneParamName;
	// MPropertySuppressField
	CUtlString m_hitOffsetParamName;
	// MPropertySuppressField
	CUtlString m_hitDirectionParamName;
	// MPropertySuppressField
	CUtlString m_hitStrengthParamName;
	// MPropertyFriendlyName = "Trigger Parameter"
	// MPropertyAttributeChoiceName = "BoolParameter"
	AnimParamID m_triggerParam;
	// MPropertyFriendlyName = "Hit Bone Parameter"
	// MPropertyAttributeChoiceName = "IntParameter"
	AnimParamID m_hitBoneParam;
	// MPropertyFriendlyName = "Hit Offset Parameter"
	// MPropertyAttributeChoiceName = "VectorParameter"
	AnimParamID m_hitOffsetParam;
	// MPropertyFriendlyName = "Hit Direction Parameter"
	// MPropertyAttributeChoiceName = "VectorParameter"
	AnimParamID m_hitDirectionParam;
	// MPropertyFriendlyName = "Hit Strength Parameter"
	// MPropertyAttributeChoiceName = "FloatParameter"
	AnimParamID m_hitStrengthParam;
	// MPropertyFriendlyName = "Bone Weights"
	// MPropertyAttributeChoiceName = "BoneMask"
	CUtlString m_weightListName;
	// MPropertyFriendlyName = "Hip Bone"
	// MPropertyAttributeChoiceName = "Bone"
	CUtlString m_hipBoneName;
	// MPropertyFriendlyName = "Hip Translation Scale"
	float32 m_flHipBoneTranslationScale; // = 1
	// MPropertyFriendlyName = "Number of bone effected"
	int32 m_nEffectedBoneCount; // = 4
	// MPropertyFriendlyName = "Max Impact Force"
	float32 m_flMaxImpactForce; // = 100
	// MPropertyFriendlyName = "Min Impact Force"
	float32 m_flMinImpactForce; // = 50
	// MPropertyFriendlyName = "Whip Impact Scale"
	float32 m_flWhipImpactScale; // = 1
	// MPropertyFriendlyName = "Counter Rotation Scale"
	float32 m_flCounterRotationScale; // = 0.5
	// MPropertyFriendlyName = "Distance Fade Scale"
	float32 m_flDistanceFadeScale; // = 1
	// MPropertyFriendlyName = "Propagation Scale"
	float32 m_flPropagationScale; // = 1
	// MPropertyFriendlyName = "Whip Delay Time"
	float32 m_flWhipDelay; // = 0.05
	// MPropertyFriendlyName = "Spring Strength"
	float32 m_flSpringStrength; // = 15
	// MPropertyFriendlyName = "Whip Spring Strength"
	float32 m_flWhipSpringStrength; // = 10
	// MPropertyFriendlyName = "Hip Dip Spring Strength"
	float32 m_flHipDipSpringStrength; // = 10
	// MPropertyFriendlyName = "Hip Dip Scale"
	float32 m_flHipDipImpactScale; // = 1
	// MPropertyFriendlyName = "Hip Dip Delay Time"
	float32 m_flHipDipDelay; // = 0.05
	// MPropertyFriendlyName = "Reset Child"
	bool m_bResetBase; // = true
};
