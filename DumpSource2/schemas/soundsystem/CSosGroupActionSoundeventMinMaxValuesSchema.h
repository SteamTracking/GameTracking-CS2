// MPropertyFriendlyName = "Soundevent Min/Max Values"
// MHasKV3TransferPolymorphicClassname
class CSosGroupActionSoundeventMinMaxValuesSchema : public CSosGroupActionSchema
{
	// MPropertyFriendlyName = "Public field name to query."
	CUtlString m_strQueryPublicFieldName; // = "min_max_query"
	// MPropertyFriendlyName = "Public field 'delay' name."
	CUtlString m_strDelayPublicFieldName; // = "delay"
	// MPropertyFriendlyName = "Exclude stopped sounds from evaluation"
	bool m_bExcludeStoppedSounds; // = true
	// MPropertyFriendlyName = "Exclude delayed sounds from evaluation"
	bool m_bExcludeDelayedSounds; // = true
	// MPropertyFriendlyName = "Exclude sounds from evaluation less than or equal to a min value threshold."
	bool m_bExcludeSoundsBelowThreshold;
	// MPropertyFriendlyName = "The minimum threshold value to exclude sounds."
	float32 m_flExcludeSoundsMinThresholdValue; // = -1
	// MPropertyFriendlyName = "Exclude sounds from evaluation greater than or equal to a max value threshold."
	bool m_bExcludSoundsAboveThreshold;
	// MPropertyFriendlyName = "The maximum threshold value to exclude sounds."
	float32 m_flExcludeSoundsMaxThresholdValue; // = -1
	// MPropertyFriendlyName = "Min value property name"
	CUtlString m_strMinValueName; // = "min"
	// MPropertyFriendlyName = "Max value property name"
	CUtlString m_strMaxValueName; // = "max"
};
