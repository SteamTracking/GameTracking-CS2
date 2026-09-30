class CLightRigSpotLight : public CLightRigLight
{
	float32 m_flOuterConeAngle; // = 90
	float32 m_flInnerConeAngle; // = 45
	bool m_bCastShadows;
};
