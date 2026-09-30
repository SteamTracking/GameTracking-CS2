class CMotionAnalysisSettings_Foot
{
	// MPropertyAutoExpandSelf
	// MPropertyDescription = "Bone name(s) that represent the 'ankle' for this foot. Used for motion analysis. If multiple specified, use the first one found in the skeleton."
	CUtlVector< CGlobalSymbol > m_AnkleBoneNames;
	// MPropertyAutoExpandSelf
	// MPropertyDescription = "Attachment point(s) generated footstep events should have their 'attachment' key set. If multiple specified, use the first one found in the model."
	CUtlVector< CGlobalSymbol > m_AttachmentNames;
	Color m_DebugColor; // = [ 255, 255, 255 ]
	// MPropertyDescription = "Type of anim event"
	CUtlString m_CreatedEventType; // = "AE_FOOTSTEP"
	// MPropertyDescription = "Value to set the 'foot' key (if nonempty)"
	CUtlString m_CreatedEventFootValue;
};
