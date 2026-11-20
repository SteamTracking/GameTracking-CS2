// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_OP_RenderSprites : public CBaseRendererSource2
{
	// MPropertyStartGroup = "Animation"
	// MPropertyFriendlyName = "sequence id override"
	// MPropertySortPriority = 500
	CParticleCollectionRendererFloatInput m_nSequenceOverride; // = { "m_flLiteralValue": -1 }
	// MPropertyFriendlyName = "Sequence Numbers Are Indices (Tools Particles Only)"
	// MParticleAdvancedField
	bool m_bSequenceNumbersAreRawSequenceIndices;
	// MPropertyStartGroup = "Orientation"
	// MPropertyFriendlyName = "orientation type"
	// MPropertySortPriority = 750
	ParticleOrientationChoiceList_t m_nOrientationType; // = "PARTICLE_ORIENTATION_SCREEN_ALIGNED"
	// MPropertyFriendlyName = "orientation control point"
	// MPropertySortPriority = 750
	// MPropertySuppressExpr = "m_nOrientationType != PARTICLE_ORIENTATION_ALIGN_TO_PARTICLE_NORMAL && m_nOrientationType != PARTICLE_ORIENTATION_SCREENALIGN_TO_PARTICLE_NORMAL"
	int32 m_nOrientationControlPoint; // = -1
	// MPropertyFriendlyName = "enable yaw for particles aligned to normals"
	// MPropertySortPriority = 750
	// MPropertySuppressExpr = "m_nOrientationType != PARTICLE_ORIENTATION_ALIGN_TO_PARTICLE_NORMAL && m_nOrientationType != PARTICLE_ORIENTATION_SCREENALIGN_TO_PARTICLE_NORMAL"
	bool m_bUseYawWithNormalAligned;
	// MPropertyStartGroup = "Fading and culling"
	// MPropertyFriendlyName = "minimum visual screen size"
	// MPropertySortPriority = 1000
	CParticleCollectionRendererFloatInput m_flMinSize;
	// MPropertyFriendlyName = "maximum visual screen size"
	// MPropertySortPriority = 1000
	CParticleCollectionRendererFloatInput m_flMaxSize; // = { "m_flLiteralValue": 5000 }
	// MPropertyFriendlyName = "sub-pixel AA scale"
	// MPropertySuppressExpr = "mod != hlx"
	// MPropertySortPriority = 1000
	CParticleCollectionRendererFloatInput m_flSubPixelAAScale; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "screen size to start fading"
	// MPropertySortPriority = 1000
	CParticleCollectionRendererFloatInput m_flStartFadeSize; // = { "m_flLiteralValue": 100000000 }
	// MPropertyFriendlyName = "screen size to fade away"
	// MPropertySortPriority = 1000
	CParticleCollectionRendererFloatInput m_flEndFadeSize; // = { "m_flLiteralValue": 200000000 }
	// MPropertyFriendlyName = "start fade dot product of normal vs view"
	// MPropertySortPriority = 1000
	float32 m_flStartFadeDot; // = 1
	// MPropertyFriendlyName = "end fade dot product of normal vs view"
	// MPropertySortPriority = 1000
	float32 m_flEndFadeDot; // = 2
	// MPropertyStartGroup = "Distance to alpha coding"
	// MPropertyFriendlyName = "distance alpha"
	// MPropertySortPriority = 0
	bool m_bDistanceAlpha;
	// MPropertyFriendlyName = "use soft edges for distance alpha"
	// MPropertySortPriority = 0
	// MPropertySuppressExpr = "!m_bDistanceAlpha"
	bool m_bSoftEdges;
	// MPropertyFriendlyName = "start value for soft edges for distance alpha"
	// MPropertySortPriority = 0
	// MPropertySuppressExpr = "!m_bDistanceAlpha"
	float32 m_flEdgeSoftnessStart; // = 0.6
	// MPropertyFriendlyName = "end value for soft edges for distance alpha"
	// MPropertySortPriority = 0
	// MPropertySuppressExpr = "!m_bDistanceAlpha"
	float32 m_flEdgeSoftnessEnd; // = 0.5
	// MPropertyStartGroup = "Outlining"
	// MPropertyFriendlyName = "enable particle outlining"
	// MPropertySortPriority = 0
	bool m_bOutline;
	// MPropertyFriendlyName = "outline color"
	// MPropertySortPriority = 0
	// MPropertySuppressExpr = "!m_bOutline"
	Color m_OutlineColor; // = [ 255, 255, 255 ]
	// MPropertyFriendlyName = "outline alpha"
	// MPropertyAttributeRange = "0 255"
	// MPropertySortPriority = 0
	// MPropertySuppressExpr = "!m_bOutline"
	int32 m_nOutlineAlpha; // = 255
	// MPropertyFriendlyName = "outline start 0"
	// MPropertySortPriority = 0
	// MPropertySuppressExpr = "!m_bOutline"
	float32 m_flOutlineStart0; // = 0.5
	// MPropertyFriendlyName = "outline start 1"
	// MPropertySortPriority = 0
	// MPropertySuppressExpr = "!m_bOutline"
	float32 m_flOutlineStart1; // = 0.6
	// MPropertyFriendlyName = "outline end 0"
	// MPropertySortPriority = 0
	// MPropertySuppressExpr = "!m_bOutline"
	float32 m_flOutlineEnd0; // = 0.7
	// MPropertyFriendlyName = "outline end 1"
	// MPropertySortPriority = 0
	// MPropertySuppressExpr = "!m_bOutline"
	float32 m_flOutlineEnd1; // = 0.8
	// MPropertyStartGroup = "Lighting and Shadows"
	// MPropertyFriendlyName = "lighting mode"
	// MPropertySortPriority = 400
	// MPropertySuppressExpr = "mod != hlx"
	ParticleLightingQuality_t m_nLightingMode; // = "PARTICLE_LIGHTING_PER_PARTICLE"
	// MPropertyFriendlyName = "lighting override"
	// MPropertySortPriority = 400
	// MPropertySuppressExpr = "m_nLightingMode != PARTICLE_LIGHTING_OVERRIDE_POSITION && m_nLightingMode != PARTICLE_LIGHTING_OVERRIDE_COLOR && m_nLightingMode != PARTICLE_LIGHTING_ADD_EXTRA_LIGHT"
	CParticleCollectionRendererVecInput m_vecLightingOverride; // = { "m_LiteralColor": [ 255, 255, 255 ], "m_nType": "PVEC_TYPE_LITERAL_COLOR" }
	// MPropertyFriendlyName = "vertex lighting tessellation (0-5)"
	// MPropertyAttributeRange = "0 5"
	// MPropertySortPriority = 400
	// MPropertySuppressExpr = "mod != hlx || m_nLightingMode != PARTICLE_LIGHTING_PER_VERTEX"
	CParticleCollectionRendererFloatInput m_flLightingTessellation;
	// MPropertyFriendlyName = "lighting directionality"
	// MPropertySortPriority = 400
	// MPropertySuppressExpr = "mod != hlx"
	CParticleCollectionRendererFloatInput m_flLightingDirectionality;
	// MPropertyFriendlyName = "Particle Shadows"
	// MPropertySortPriority = 400
	// MPropertySuppressExpr = "mod != csgo"
	bool m_bParticleShadows;
	// MPropertyFriendlyName = "Shadow Density"
	// MPropertySortPriority = 400
	// MPropertySuppressExpr = "!m_bParticleShadows"
	float32 m_flShadowDensity; // = 1
};
