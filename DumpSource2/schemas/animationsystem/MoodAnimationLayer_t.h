// MPropertyArrayElementNameKey = "m_sName"
class MoodAnimationLayer_t
{
	// MPropertyFriendlyName = "Name"
	// MPropertyDescription = "Name of the layer"
	CUtlString m_sName;
	// MPropertyFriendlyName = "Active When Listening"
	// MPropertyDescription = "Sets the mood's animation buckets to be active when the character is listening"
	bool m_bActiveListening; // = true
	// MPropertyFriendlyName = "Active When Talking"
	// MPropertyDescription = "Sets the mood's animation buckets to be active when the character is talking"
	bool m_bActiveTalking; // = true
	// MPropertyDescription = "List of animations to choose from"
	CUtlVector< MoodAnimation_t > m_layerAnimations;
	// MPropertyDescription = "Intensity of the animation"
	// MPropertyAttributeRange = "0 1"
	CRangeFloat m_flIntensity; // = 1
	// MPropertyDescription = "Multiplier of the animation duration"
	CRangeFloat m_flDurationScale; // = 1
	// MPropertyDescription = "When scaling an animation, grab the scale value as in int. Used for gestures/postures to control number of looping sections"
	bool m_bScaleWithInts;
	// MPropertyDescription = "Time before the next animation can start"
	CRangeFloat m_flNextStart; // = 1
	// MPropertyDescription = "Time from the start of the mood before an animation can start"
	CRangeFloat m_flStartOffset;
	// MPropertyDescription = "Time from the end of the mood when an animation cannot play"
	CRangeFloat m_flEndOffset;
	// MPropertyDescription = "Fade in time of the animation"
	float32 m_flFadeIn; // = 0.2
	// MPropertyDescription = "Fade out time of the animation"
	float32 m_flFadeOut; // = 0.2
};
