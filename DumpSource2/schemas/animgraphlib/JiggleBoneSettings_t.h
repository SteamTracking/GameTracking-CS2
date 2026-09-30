class JiggleBoneSettings_t
{
	int32 m_nBoneIndex;
	float32 m_flSpringStrength;
	float32 m_flMaxTimeStep;
	float32 m_flDamping;
	Vector m_vBoundsMaxLS;
	Vector m_vBoundsMinLS;
	JiggleBoneSimSpace m_eSimSpace; // = "SimSpace_Local"
};
