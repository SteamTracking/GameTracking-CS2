// MHasKV3TransferPolymorphicClassname
class C_OP_RenderStatusEffectTf : public CParticleFunctionRenderer
{
	// MPropertyFriendlyName = "color warp texture (3d)"
	// MPropertyAttributeEditor = "AssetBrowse( vtex, *showassetpreview )"
	CStrongHandle< InfoForResourceTypeCTextureBase > m_pTextureColorWarp;
	// MPropertyFriendlyName = "normal texture"
	// MPropertyAttributeEditor = "AssetBrowse( vtex, *showassetpreview )"
	CStrongHandle< InfoForResourceTypeCTextureBase > m_pTextureNormal;
	// MPropertyFriendlyName = "metalness texture"
	// MPropertyAttributeEditor = "AssetBrowse( vtex, *showassetpreview )"
	CStrongHandle< InfoForResourceTypeCTextureBase > m_pTextureMetalness;
	// MPropertyFriendlyName = "roughness texture"
	// MPropertyAttributeEditor = "AssetBrowse( vtex, *showassetpreview )"
	CStrongHandle< InfoForResourceTypeCTextureBase > m_pTextureRoughness;
	// MPropertyFriendlyName = "self illum texture"
	// MPropertyAttributeEditor = "AssetBrowse( vtex, *showassetpreview )"
	CStrongHandle< InfoForResourceTypeCTextureBase > m_pTextureSelfIllum;
	// MPropertyFriendlyName = "detail texture"
	// MPropertyAttributeEditor = "AssetBrowse( vtex, *showassetpreview )"
	CStrongHandle< InfoForResourceTypeCTextureBase > m_pTextureDetail;
	// MPropertyFriendlyName = "environment map texture"
	// MPropertyAttributeEditor = "AssetBrowse( vtex, *showassetpreview )"
	CStrongHandle< InfoForResourceTypeCTextureBase > m_pTextureEnvMap;
};
