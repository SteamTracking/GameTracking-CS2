class TextureGroup_t
{
	// MPropertyFriendlyName = "Enabled"
	bool m_bEnabled; // = true
	// MPropertyFriendlyName = "Author Texture As Gradient"
	// MPropertySuppressExpr = "( m_nTextureType == SPRITECARD_TEXTURE_NORMALMAP || m_nTextureType == SPRITECARD_TEXTURE_ANIMMOTIONVEC || m_nTextureType == SPRITECARD_TEXTURE_6POINT_XYZ_A || m_nTextureType == SPRITECARD_TEXTURE_6POINT_NEGXYZ_E || m_nTextureType == SPRITECARD_TEXTURE_SPHERICAL_HARMONICS_A || m_nTextureType == SPRITECARD_TEXTURE_SPHERICAL_HARMONICS_B || m_nTextureType == SPRITECARD_TEXTURE_SPHERICAL_HARMONICS_C || m_nTextureType == SPRITECARD_TEXTURE_ILLUMINATION_GRADIENT || m_nTextureType == SPRITECARD_TEXTURE_DEPTH )"
	bool m_bReplaceTextureWithGradient;
	// MPropertyFriendlyName = "Texture"
	// MPropertySuppressExpr = "m_bReplaceTextureWithGradient"
	// MPropertyAttributeEditor = "AssetBrowse( vtex, *showassetpreview )"
	CStrongHandle< InfoForResourceTypeCTextureBase > m_hTexture;
	// MPropertyFriendlyName = "Gradient"
	// MPropertySuppressExpr = "!m_bReplaceTextureWithGradient"
	CColorGradient m_Gradient;
	// MPropertyFriendlyName = "Texture Type"
	SpriteCardTextureType_t m_nTextureType; // = "SPRITECARD_TEXTURE_DIFFUSE"
	// MPropertyFriendlyName = "Channel Mix"
	// MPropertySuppressExpr = "( m_nTextureType == SPRITECARD_TEXTURE_NORMALMAP || m_nTextureType == SPRITECARD_TEXTURE_ANIMMOTIONVEC || m_nTextureType == SPRITECARD_TEXTURE_6POINT_XYZ_A || m_nTextureType == SPRITECARD_TEXTURE_6POINT_NEGXYZ_E || m_nTextureType == SPRITECARD_TEXTURE_SPHERICAL_HARMONICS_A || m_nTextureType == SPRITECARD_TEXTURE_SPHERICAL_HARMONICS_B || m_nTextureType == SPRITECARD_TEXTURE_SPHERICAL_HARMONICS_C || m_nTextureType == SPRITECARD_TEXTURE_ILLUMINATION_GRADIENT || m_nTextureType == SPRITECARD_TEXTURE_DEPTH )"
	SpriteCardTextureChannel_t m_nTextureChannels; // = "SPRITECARD_TEXTURE_CHANNEL_MIX_RGBA"
	// MPropertyFriendlyName = "Mix Blend Mode"
	// MPropertySuppressExpr = "( m_nTextureType == SPRITECARD_TEXTURE_NORMALMAP || m_nTextureType == SPRITECARD_TEXTURE_ANIMMOTIONVEC || m_nTextureType == SPRITECARD_TEXTURE_6POINT_XYZ_A || m_nTextureType == SPRITECARD_TEXTURE_6POINT_NEGXYZ_E || m_nTextureType == SPRITECARD_TEXTURE_SPHERICAL_HARMONICS_A || m_nTextureType == SPRITECARD_TEXTURE_SPHERICAL_HARMONICS_B || m_nTextureType == SPRITECARD_TEXTURE_SPHERICAL_HARMONICS_C || m_nTextureType == SPRITECARD_TEXTURE_ILLUMINATION_GRADIENT || m_nTextureType == SPRITECARD_TEXTURE_DEPTH )"
	ParticleTextureLayerBlendType_t m_nTextureBlendMode; // = "SPRITECARD_TEXTURE_BLEND_MULTIPLY"
	// MPropertyFriendlyName = "Blend Amount"
	// MPropertySuppressExpr = "( m_nTextureType == SPRITECARD_TEXTURE_NORMALMAP || m_nTextureType == SPRITECARD_TEXTURE_ANIMMOTIONVEC || m_nTextureType == SPRITECARD_TEXTURE_6POINT_XYZ_A || m_nTextureType == SPRITECARD_TEXTURE_6POINT_NEGXYZ_E || m_nTextureType == SPRITECARD_TEXTURE_SPHERICAL_HARMONICS_A || m_nTextureType == SPRITECARD_TEXTURE_SPHERICAL_HARMONICS_B || m_nTextureType == SPRITECARD_TEXTURE_SPHERICAL_HARMONICS_C || m_nTextureType == SPRITECARD_TEXTURE_ILLUMINATION_GRADIENT || m_nTextureType == SPRITECARD_TEXTURE_DEPTH )"
	CParticleCollectionRendererFloatInput m_flTextureBlend; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "Texture Controls"
	// MPropertySuppressExpr = "( m_nTextureType == SPRITECARD_TEXTURE_NORMALMAP || m_nTextureType == SPRITECARD_TEXTURE_ANIMMOTIONVEC || m_nTextureType == SPRITECARD_TEXTURE_6POINT_XYZ_A || m_nTextureType == SPRITECARD_TEXTURE_6POINT_NEGXYZ_E || m_nTextureType == SPRITECARD_TEXTURE_SPHERICAL_HARMONICS_A || m_nTextureType == SPRITECARD_TEXTURE_SPHERICAL_HARMONICS_B || m_nTextureType == SPRITECARD_TEXTURE_SPHERICAL_HARMONICS_C || m_nTextureType == SPRITECARD_TEXTURE_ILLUMINATION_GRADIENT || m_nTextureType == SPRITECARD_TEXTURE_DEPTH )"
	TextureControls_t m_TextureControls;
};
