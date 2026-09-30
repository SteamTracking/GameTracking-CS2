// MHasKV3TransferPolymorphicClassname
class CCS2ChickenGraphController : public CAnimGraphControllerBase
{
	CAnimGraph2ParamOptionalRef< CGlobalSymbol > m_action;
	CAnimGraph2ParamAutoResetOptionalRef m_bActionReset;
	CAnimGraph2ParamOptionalRef< float32 > m_actionVariation;
	CAnimGraph2ParamOptionalRef< bool > m_bInWater;
	CAnimGraph2ParamOptionalRef< CGlobalSymbol > m_mode;
	CAnimGraph2ParamOptionalRef< CGlobalSymbol > m_lifeStage;
	CAnimGraph2ParamOptionalRef< float32 > m_idlePhase;
	CAnimGraph2ParamOptionalRef< float32 > m_turnAngle;
	CAnimGraph2ParamOptionalRef< bool > m_bHasLookatTarget;
	CAnimGraph2ParamOptionalRef< Vector > m_lookatTarget;
	CAnimGraph2ParamOptionalRef< bool > m_bFlinch;
	CAnimGraph2ParamOptionalRef< float32 > m_flinchVariation;
	bool m_bHasActionCompletedEvent;
};
