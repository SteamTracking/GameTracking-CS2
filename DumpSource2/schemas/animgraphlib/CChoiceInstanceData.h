class CChoiceInstanceData
{
	CAnimNetVar< int32 > m_currentChoice; // = -1
	int32 m_previousChoice; // = -1
	CAnimNetVar< float32 > m_flClipStartTime;
	float32 m_choicePreviousCycle;
};
