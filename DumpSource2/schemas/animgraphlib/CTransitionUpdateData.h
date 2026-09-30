class CTransitionUpdateData
{
	uint8 m_srcStateIndex;
	uint8 m_destStateIndex;
	bitfield:7 m_nHandshakeMaskToDisableFirst;
	bitfield:1 m_bDisabled;
};
