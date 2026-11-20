class TextureControls_t
{
	// MPropertyFriendlyName = "horizontal texture scale"
	CParticleCollectionRendererFloatInput m_flFinalTextureScaleU; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "vertical texture scale"
	CParticleCollectionRendererFloatInput m_flFinalTextureScaleV; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "horizontal texture offset"
	CParticleCollectionRendererFloatInput m_flFinalTextureOffsetU;
	// MPropertyFriendlyName = "vertical texture offset"
	CParticleCollectionRendererFloatInput m_flFinalTextureOffsetV;
	// MPropertyFriendlyName = "texture rotation / animation rate scale"
	CParticleCollectionRendererFloatInput m_flFinalTextureUVRotation;
	// MPropertyFriendlyName = "Infinite Zoom Scale"
	CParticleCollectionRendererFloatInput m_flZoomScale; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "Distortion Amount"
	CParticleCollectionRendererFloatInput m_flDistortion; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "Randomize Initial Offset"
	bool m_bRandomizeOffsets;
	// MPropertyFriendlyName = "Clamp UVs"
	bool m_bClampUVs;
	// MPropertyFriendlyName = "per-particle scalar for blend"
	SpriteCardPerParticleScale_t m_nPerParticleBlend; // = "SPRITECARD_TEXTURE_PP_SCALE_NONE"
	// MPropertyFriendlyName = "per-particle scalar for scale"
	SpriteCardPerParticleScale_t m_nPerParticleScale; // = "SPRITECARD_TEXTURE_PP_SCALE_NONE"
	// MPropertyFriendlyName = "per-particle scalar for horizontal offset"
	SpriteCardPerParticleScale_t m_nPerParticleOffsetU; // = "SPRITECARD_TEXTURE_PP_SCALE_NONE"
	// MPropertyFriendlyName = "per-particle scalar for vertical offset"
	SpriteCardPerParticleScale_t m_nPerParticleOffsetV; // = "SPRITECARD_TEXTURE_PP_SCALE_NONE"
	// MPropertyFriendlyName = "per-particle scalar for rotation"
	SpriteCardPerParticleScale_t m_nPerParticleRotation; // = "SPRITECARD_TEXTURE_PP_SCALE_NONE"
	// MPropertyFriendlyName = "per-particle scalar for zoom"
	SpriteCardPerParticleScale_t m_nPerParticleZoom; // = "SPRITECARD_TEXTURE_PP_SCALE_NONE"
	// MPropertyFriendlyName = "per-particle scalar for distortion"
	SpriteCardPerParticleScale_t m_nPerParticleDistortion; // = "SPRITECARD_TEXTURE_PP_SCALE_NONE"
};
