class CPulseCell_TestWaitWithCursorState::CursorState_t
{
	float32 flWaitValue;
	bool bFail;
	HYieldedCursor m_hSelfCursor; // = { "m_hGraph": { "m_nGraphID": 0 }, "m_nCursorID": -1, "m_nYieldToken": -1 }
	HPulseCellBase m_hSelfCellInstanceUntyped; // = { "m_hGraph": { "m_nGraphID": 0 }, "m_nCellID": -1 }
	HPulseCell< CPulseCell_TestWaitWithCursorState > m_hSelfCellInstance; // = { "m_hGraph": { "m_nGraphID": 0 }, "m_nCellID": -1 }
};
