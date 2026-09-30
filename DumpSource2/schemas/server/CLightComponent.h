// MHasKV3TransferPolymorphicClassname
class CLightComponent : public CEntityComponent
{
	// MNotSaved
	CNetworkVarChainer __m_pChainEntity;
	Color m_Color;
	Color m_SecondaryColor;
	float32 m_flBrightness;
	float32 m_flBrightnessScale; // = 1
	float32 m_flBrightnessMult; // = 1
	float32 m_flRange;
	float32 m_flFalloff;
	float32 m_flAttenuation0;
	float32 m_flAttenuation1;
	float32 m_flAttenuation2;
	float32 m_flTheta;
	float32 m_flPhi;
	CStrongHandle< InfoForResourceTypeCTextureBase > m_hLightCookie;
	int32 m_nCascades;
	int32 m_nCastShadows;
	int32 m_nShadowWidth;
	int32 m_nShadowHeight;
	bool m_bRenderDiffuse; // = true
	int32 m_nRenderSpecular; // = 1
	bool m_bRenderTransmissive; // = true
	float32 m_flOrthoLightWidth;
	float32 m_flOrthoLightHeight;
	int32 m_nStyle;
	CUtlString m_Pattern;
	int32 m_nCascadeRenderStaticObjects; // = -1
	float32 m_flShadowCascadeCrossFade;
	float32 m_flShadowCascadeDistanceFade;
	float32 m_flShadowCascadeDistance0;
	float32 m_flShadowCascadeDistance1;
	float32 m_flShadowCascadeDistance2;
	float32 m_flShadowCascadeDistance3;
	int32 m_nShadowCascadeResolution0;
	int32 m_nShadowCascadeResolution1;
	int32 m_nShadowCascadeResolution2;
	int32 m_nShadowCascadeResolution3;
	bool m_bUsesBakedShadowing;
	int32 m_nShadowPriority; // = -1
	int32 m_nBakedShadowIndex; // = -1
	int32 m_nLightPathUniqueId;
	int32 m_nLightMapUniqueId;
	bool m_bRenderToCubemaps; // = true
	bool m_bAllowSSTGeneration; // = true
	int32 m_nDirectLight;
	int32 m_nBounceLight;
	float32 m_flBounceScale;
	float32 m_flFadeMinDist;
	float32 m_flFadeMaxDist;
	float32 m_flShadowFadeMinDist;
	float32 m_flShadowFadeMaxDist;
	bool m_bEnabled;
	bool m_bFlicker;
	bool m_bPrecomputedFieldsValid;
	Vector m_vPrecomputedBoundsMins;
	Vector m_vPrecomputedBoundsMaxs;
	Vector m_vPrecomputedOBBOrigin;
	QAngle m_vPrecomputedOBBAngles;
	Vector m_vPrecomputedOBBExtent;
	float32 m_flPrecomputedMaxRange;
	int32 m_nFogLightingMode;
	float32 m_flFogContributionStength; // = 1
	float32 m_flNearClipPlane; // = 1
	Color m_SkyColor;
	float32 m_flSkyIntensity;
	Color m_SkyAmbientBounce;
	bool m_bUseSecondaryColor;
	// MNotSaved
	bool m_bMixedShadows;
	GameTime_t m_flLightStyleStartTime;
	float32 m_flCapsuleLength;
	float32 m_flMinRoughness;
	bool m_bPvsModifyEntity;
};
