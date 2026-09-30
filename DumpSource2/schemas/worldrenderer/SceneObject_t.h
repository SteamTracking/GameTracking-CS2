class SceneObject_t
{
	uint32 m_nObjectID;
	Vector4D[3] m_vTransform;
	float32 m_flFadeStartDistance;
	float32 m_flFadeEndDistance;
	Vector4D m_vTintColor; // = [ 1, 1, 1, 1 ]
	CUtlString m_skin;
	ObjectTypeFlags_t m_nObjectTypeFlags; // = "OBJECT_TYPE_MODEL"
	Vector m_vLightingOrigin; // = [ 340282346638528859811704183484516925440, 340282346638528859811704183484516925440, 340282346638528859811704183484516925440 ]
	int16 m_nOverlayRenderOrder;
	int16 m_nLODOverride; // = -1
	int32 m_nCubeMapPrecomputedHandshake;
	int32 m_nLightProbeVolumePrecomputedHandshake;
	float32 m_flEmissiveLightingBoost; // = 1
	CStrongHandle< InfoForResourceTypeCModel > m_renderableModel;
	CStrongHandle< InfoForResourceTypeCRenderMesh > m_renderable;
};
