// MHasKV3TransferPolymorphicClassname
class CLevelsColorCorrectionLayer : public CColorCorrectionLayer
{
	int32 m_nInputBlackPointRGB;
	int32 m_nInputBlackPointR;
	int32 m_nInputBlackPointG;
	int32 m_nInputBlackPointB;
	int32 m_nInputWhitePointRGB; // = 255
	int32 m_nInputWhitePointR; // = 255
	int32 m_nInputWhitePointG; // = 255
	int32 m_nInputWhitePointB; // = 255
	int32 m_nOutputBlackPointRGB;
	int32 m_nOutputBlackPointR;
	int32 m_nOutputBlackPointG;
	int32 m_nOutputBlackPointB;
	int32 m_nOutputWhitePointRGB; // = 255
	int32 m_nOutputWhitePointR; // = 255
	int32 m_nOutputWhitePointG; // = 255
	int32 m_nOutputWhitePointB; // = 255
	float32 m_flGammaRGB; // = 1
	float32 m_flGammaR; // = 1
	float32 m_flGammaG; // = 1
	float32 m_flGammaB; // = 1
};
