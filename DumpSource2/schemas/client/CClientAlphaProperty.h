// MHasKV3TransferPolymorphicClassname
class CClientAlphaProperty : public IClientAlphaProperty
{
	uint16 m_nDistFadeStart;
	uint16 m_nDistFadeEnd;
	bitfield:14 m_nDesyncOffset;
	bitfield:1 m_bAlphaOverride;
	bitfield:1 m_bShadowAlphaOverride;
	bitfield:3 m_nRenderMode;
	bitfield:5 m_nRenderFX;
	uint8 m_nAlpha; // = 255
	float32 m_flFadeScale;
	GameTime_t m_flRenderFxStartTime;
	float32 m_flRenderFxDuration;
};
