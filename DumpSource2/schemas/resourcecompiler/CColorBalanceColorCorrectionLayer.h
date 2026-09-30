// MHasKV3TransferPolymorphicClassname
class CColorBalanceColorCorrectionLayer : public CColorCorrectionLayer
{
	int32 m_nRedCyanBalS;
	int32 m_nRedCyanBalM;
	int32 m_nRedCyanBalH;
	int32 m_nGreenMagentaBalS;
	int32 m_nGreenMagentaBalM;
	int32 m_nGreenMagentaBalH;
	int32 m_nBlueYellowBalS;
	int32 m_nBlueYellowBalM;
	int32 m_nBlueYellowBalH;
	bool m_bPreserveLuminosity; // = true
};
