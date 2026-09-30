// MVDataRoot
// MVDataAssociatedFile = "toolscenelightrigs.vdata"
class CToolSceneLightRig
{
	LightRigType_t m_nRigType; // = "PREVIEW"
	CUtlVector< CLightRigSunLight > m_Suns;
	CUtlVector< CLightRigPointLight > m_PointLights;
	CUtlVector< CLightRigSpotLight > m_SpotLights;
	CLightRigBackground m_Background;
	CLightRigGrid m_Grid; // = { "m_Color": [ 0, 0, 0, 0 ], "m_bEnabled": true }
	CLightRigExposure m_Exposure; // = { "m_bEnabled": false, "m_flMaxEV": 2, "m_flMinEV": -2 }
	CLightRigPostProcessing m_PostProcessing;
	CLightRigSky m_Sky;
	CLightRigVMap m_BackgroundMap; // = { "m_MapName": "", "m_bParticlesTraceAgainstMap": false, "m_bRender3DSkybox": true }
};
