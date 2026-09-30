// MHasKV3TransferPolymorphicClassname
class CParticleFunction
{
	// MPropertyFriendlyName = "operator strength"
	// MPropertySortPriority = -100
	CParticleCollectionFloatInput m_flOpStrength;
	// MPropertyFriendlyName = "operator end cap state"
	// MPropertySortPriority = -100
	ParticleEndcapMode_t m_nOpEndCapState;
	// MPropertyFriendlyName = "operator enabled in tools or game only"
	// MPropertySortPriority = -100
	ParticleToolsState_t m_nToolsState;
	// MPropertyStartGroup = "Operator Fade"
	// MPropertyFriendlyName = "operator start fadein"
	// MParticleAdvancedField
	// MPropertySortPriority = -100
	float32 m_flOpStartFadeInTime;
	// MPropertyFriendlyName = "operator end fadein"
	// MParticleAdvancedField
	// MPropertySortPriority = -100
	float32 m_flOpEndFadeInTime;
	// MPropertyFriendlyName = "operator start fadeout"
	// MParticleAdvancedField
	// MPropertySortPriority = -100
	float32 m_flOpStartFadeOutTime;
	// MPropertyFriendlyName = "operator end fadeout"
	// MParticleAdvancedField
	// MPropertySortPriority = -100
	float32 m_flOpEndFadeOutTime;
	// MPropertyFriendlyName = "operator fade oscillate"
	// MParticleAdvancedField
	// MPropertySortPriority = -100
	float32 m_flOpFadeOscillatePeriod;
	// MPropertyFriendlyName = "normalize fade times to endcap"
	// MParticleAdvancedField
	// MPropertySortPriority = -100
	bool m_bNormalizeToStopTime;
	// MPropertyStartGroup = "Operator Fade Time Offset"
	// MPropertyFriendlyName = "operator fade time offset min"
	// MParticleAdvancedField
	// MPropertySortPriority = -100
	float32 m_flOpTimeOffsetMin;
	// MPropertyFriendlyName = "operator fade time offset max"
	// MParticleAdvancedField
	// MPropertySortPriority = -100
	float32 m_flOpTimeOffsetMax;
	// MPropertyFriendlyName = "operator fade time offset seed"
	// MParticleAdvancedField
	// MPropertySortPriority = -100
	int32 m_nOpTimeOffsetSeed;
	// MPropertyStartGroup = "Operator Fade Timescale Modifiers"
	// MPropertyFriendlyName = "operator fade time scale seed"
	// MParticleAdvancedField
	// MPropertySortPriority = -100
	int32 m_nOpTimeScaleSeed;
	// MPropertyFriendlyName = "operator fade time scale min"
	// MParticleAdvancedField
	// MPropertySortPriority = -100
	float32 m_flOpTimeScaleMin;
	// MPropertyFriendlyName = "operator fade time scale max"
	// MParticleAdvancedField
	// MPropertySortPriority = -100
	float32 m_flOpTimeScaleMax;
	// MPropertyStartGroup = ""
	// MPropertySuppressField
	bool m_bDisableOperator;
	// MPropertyFriendlyName = "operator help and notes"
	// MParticleHelpField
	// MPropertyAttributeEditor = "TextBlock()"
	// MPropertySortPriority = -100
	CUtlString m_Notes;
};
