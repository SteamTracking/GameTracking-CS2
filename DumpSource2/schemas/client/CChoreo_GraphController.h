// MHasKV3TransferPolymorphicClassname
class CChoreo_GraphController : public CAnimGraphControllerBase
{
	CAnimGraph2ParamOptionalRef< CGlobalSymbol > m_eChoreoState;
	CAnimGraph2ParamOptionalRef< CTransform > m_tChoreoTargetWarp;
	CAnimGraph2ParamOptionalRef< CTransform > m_tChoreoExitWarp;
};
