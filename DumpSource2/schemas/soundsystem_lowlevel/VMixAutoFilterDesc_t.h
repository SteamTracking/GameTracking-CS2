class VMixAutoFilterDesc_t
{
	float32 m_flEnvelopeAmount;
	float32 m_flAttackTimeMS; // = 5
	float32 m_flReleaseTimeMS; // = 200
	VMixFilterDesc_t m_filter;
	float32 m_flLFOAmount;
	float32 m_flLFORate;
	float32 m_flPhase;
	VMixLFOShape_t m_nLFOShape; // = "LFO_SHAPE_SINE"
};
