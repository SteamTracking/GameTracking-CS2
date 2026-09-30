class CPulse_BlackboardReference
{
	CStrongHandle< InfoForResourceTypeIPulseGraphDef > m_hBlackboardResource;
	PulseSymbol_t m_BlackboardResource;
	PulseDocNodeID_t m_nNodeID; // = -1
	CGlobalSymbol m_NodeName;
};
