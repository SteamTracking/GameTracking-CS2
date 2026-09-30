class CNmGraphDocFlowGraph::Connection_t
{
	V_uuid_t m_ID;
	V_uuid_t m_fromNodeID; // = "00000000-0000-0000-0000-000000000000"
	V_uuid_t m_outputPinID;
	V_uuid_t m_toNodeID; // = "00000000-0000-0000-0000-000000000000"
	V_uuid_t m_inputPinID; // = "00000000-0000-0000-0000-000000000000"
};
