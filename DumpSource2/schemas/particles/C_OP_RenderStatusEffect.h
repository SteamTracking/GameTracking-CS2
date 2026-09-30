// MHasKV3TransferPolymorphicClassname
class C_OP_RenderStatusEffect : public CParticleFunctionRenderer
{
	// MPropertyFriendlyName = "color warp texture (3d)"
	// MPropertyAttributeEditor = "AssetBrowse( vtex, *showassetpreview )"
	CStrongHandle< InfoForResourceTypeCTextureBase > m_pTextureColorWarp;
	// MPropertyFriendlyName = "detail 2 texture"
	// MPropertyAttributeEditor = "AssetBrowse( vtex, *showassetpreview )"
	CStrongHandle< InfoForResourceTypeCTextureBase > m_pTextureDetail2;
	// MPropertyFriendlyName = "diffuse warp texture (3d)"
	// MPropertyAttributeEditor = "AssetBrowse( vtex, *showassetpreview )"
	CStrongHandle< InfoForResourceTypeCTextureBase > m_pTextureDiffuseWarp;
	// MPropertyFriendlyName = "fresnel color warp texture (3d)"
	// MPropertyAttributeEditor = "AssetBrowse( vtex, *showassetpreview )"
	CStrongHandle< InfoForResourceTypeCTextureBase > m_pTextureFresnelColorWarp;
	// MPropertyFriendlyName = "fresnel warp texture"
	// MPropertyAttributeEditor = "AssetBrowse( vtex, *showassetpreview )"
	CStrongHandle< InfoForResourceTypeCTextureBase > m_pTextureFresnelWarp;
	// MPropertyFriendlyName = "specular warp texture"
	// MPropertyAttributeEditor = "AssetBrowse( vtex, *showassetpreview )"
	CStrongHandle< InfoForResourceTypeCTextureBase > m_pTextureSpecularWarp;
	// MPropertyFriendlyName = "environment map texture"
	// MPropertyAttributeEditor = "AssetBrowse( vtex, *showassetpreview )"
	CStrongHandle< InfoForResourceTypeCTextureBase > m_pTextureEnvMap;
};
