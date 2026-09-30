// MPropertyFriendlyName = "Soundevent Count"
// MHasKV3TransferPolymorphicClassname
class CSosGroupActionSoundeventCountSchema : public CSosGroupActionSchema
{
	// MPropertyFriendlyName = "Exclude Stopped Sounds from Count"
	bool m_bExcludeStoppedSounds; // = true
	// MPropertyFriendlyName = "Result Current Count"
	CUtlString m_strCountKeyName; // = "current_count"
};
