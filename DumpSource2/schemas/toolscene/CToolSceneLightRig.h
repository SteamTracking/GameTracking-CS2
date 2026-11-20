// MVDataRoot
// MVDataAssociatedFile = "toolscenelightrigs.vdata"
class CToolSceneLightRig
{
	LightRigType_t m_nRigType; // = "PREVIEW"
	CUtlVector< CLightRigSunLight > m_Suns;
	CUtlVector< CLightRigPointLight > m_PointLights;
	CUtlVector< CLightRigSpotLight > m_SpotLights;
	CLightRigBackground m_Background;
	CLightRigGrid m_Grid;
	CLightRigExposure m_Exposure;
	CLightRigPostProcessing m_PostProcessing;
	CLightRigSky m_Sky;
	CLightRigVMap m_BackgroundMap;
};
