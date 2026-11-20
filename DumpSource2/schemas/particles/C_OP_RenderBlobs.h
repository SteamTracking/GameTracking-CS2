// MHasKV3TransferPolymorphicClassname
class C_OP_RenderBlobs : public CParticleFunctionRenderer
{
	// MPropertyFriendlyName = "cube width"
	CParticleCollectionRendererFloatInput m_cubeWidth; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "cutoff radius"
	CParticleCollectionRendererFloatInput m_cutoffRadius; // = { "m_flLiteralValue": 3.3 }
	// MPropertyFriendlyName = "render radius"
	CParticleCollectionRendererFloatInput m_renderRadius; // = { "m_flLiteralValue": 1.3 }
	// MPropertyFriendlyName = "(optional) vertex buffer size (k)"
	// MPropertyAttributeRange = "0 1024"
	uint32 m_nVertexCountKb;
	// MPropertyFriendlyName = "(optional) index buffer size (k)"
	// MPropertyAttributeRange = "0 1024"
	uint32 m_nIndexCountKb;
	// MPropertyFriendlyName = "scale CP (cube width/cutoff/render = x/y/z)"
	int32 m_nScaleCP; // = -1
	// MPropertyFriendlyName = "material variables"
	// MPropertyAutoExpandSelf
	// MPropertySortPriority = 600
	CUtlVector< MaterialVariable_t > m_MaterialVars;
	CStrongHandle< InfoForResourceTypeIMaterial2 > m_hMaterial;
};
