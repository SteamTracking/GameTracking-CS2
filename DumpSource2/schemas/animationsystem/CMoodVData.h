// MVDataRoot
// MVDataOverlayType = 1
class CMoodVData
{
	// MPropertyDescription = "Model to get the animation list from"
	// MPropertyProvidesEditContextString = "ToolEditContext_ID_VMDL"
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeCModel > > m_sModelName;
	// MPropertyDescription = "Type of mood"
	MoodType_t m_nMoodType; // = "eMoodType_Head"
	// MPropertyDescription = "Layers for this mood"
	CUtlVector< MoodAnimationLayer_t > m_animationLayers;
};
