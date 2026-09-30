class CLightRigLight
{
	Vector m_vPosition;
	Vector m_vDirection;
	Vector m_vLookAt;
	Color m_Color; // = [ 255, 255, 255 ]
	float32 m_flAxisScale; // = 1
	float32 m_flRadius; // = 10000
	float32 m_flBrightness; // = 1
	float32 m_flLightSourceRadius;
	float32 m_flDistance; // = 1.5
	bool m_bRelativePositioning;
	bool m_bParentToCamera;
};
