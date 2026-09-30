// MHasKV3TransferPolymorphicClassname
class CCS2UIPawnGraphController : public CAnimGraphControllerBase
{
	CAnimGraph2ParamOptionalRef< float32 > m_nAnimationSeed;
	CAnimGraph2ParamOptionalRef< CGlobalSymbol > m_characterMode;
	CAnimGraph2ParamOptionalRef< bool > m_bCharacterModeReset;
	CAnimGraph2ParamOptionalRef< float32 > m_nTeamPreviewVariant;
	CAnimGraph2ParamOptionalRef< float32 > m_nTeamPreviewRandom;
	CAnimGraph2ParamOptionalRef< float32 > m_nTeamPreviewPosition;
	CAnimGraph2ParamOptionalRef< CGlobalSymbol > m_endOfMatchCelebration;
	CAnimGraph2ParamOptionalRef< CGlobalSymbol > m_action;
	CAnimGraph2ParamOptionalRef< CGlobalSymbol > m_bannerAnimation;
	CAnimGraph2ParamOptionalRef< CGlobalSymbol > m_weaponCategory;
	CAnimGraph2ParamOptionalRef< CGlobalSymbol > m_weaponType;
	CAnimGraph2ParamOptionalRef< CGlobalSymbol > m_weaponState;
	CAnimGraph2ParamOptionalRef< float32 > m_inspectTurnAngle;
	CAnimGraph2ParamOptionalRef< float32 > m_nChickSnapshotVariant;
	CAnimGraph2ParamOptionalRef< float32 > m_nChickLifeStage;
	CAnimGraph2ParamOptionalRef< bool > m_bCT;
};
