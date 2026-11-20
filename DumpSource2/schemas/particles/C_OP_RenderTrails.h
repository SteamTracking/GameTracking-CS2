// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_OP_RenderTrails : public CBaseTrailRenderer
{
	// MPropertyStartGroup = "Screenspace Fading and culling"
	// MPropertyFriendlyName = "enable fading and clamping"
	// MPropertySortPriority = 1000
	bool m_bEnableFadingAndClamping;
	// MPropertyFriendlyName = "start fade dot product of normal vs view"
	// MPropertySortPriority = 1000
	float32 m_flStartFadeDot; // = 1
	// MPropertyFriendlyName = "end fade dot product of normal vs view"
	// MPropertySortPriority = 1000
	float32 m_flEndFadeDot; // = 2
	// MPropertyStartGroup = "+Trail Length"
	// MPropertyFriendlyName = "Anchor point source"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	// MPropertySortPriority = 800
	ParticleAttributeIndex_t m_nPrevPntSource; // = 2
	// MPropertyFriendlyName = "max length"
	// MPropertySortPriority = 800
	float32 m_flMaxLength; // = 2000
	// MPropertyFriendlyName = "min length"
	// MPropertySortPriority = 800
	float32 m_flMinLength;
	// MPropertyFriendlyName = "ignore delta time"
	// MPropertySortPriority = 800
	bool m_bIgnoreDT;
	// MPropertyFriendlyName = "constrain radius to no more than this times the length"
	// MPropertySortPriority = 800
	float32 m_flConstrainRadiusToLengthRatio; // = 1
	// MPropertyFriendlyName = "amount to scale trail length by"
	float32 m_flLengthScale; // = 1
	// MPropertyFriendlyName = "how long before a trail grows to its full length"
	float32 m_flLengthFadeInTime;
	// MPropertyStartGroup = "Trail Head & Tail"
	// MPropertyFriendlyName = "head taper scale"
	// MPropertySortPriority = 800
	CPerParticleFloatInput m_flRadiusHeadTaper; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "head color scale"
	CParticleCollectionVecInput m_vecHeadColorScale; // = { "m_LiteralColor": [ 255, 255, 255 ], "m_nType": "PVEC_TYPE_LITERAL_COLOR" }
	// MPropertyFriendlyName = "head alpha scale"
	CPerParticleFloatInput m_flHeadAlphaScale; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "tail taper scale"
	CPerParticleFloatInput m_flRadiusTaper; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "tail color scale"
	CParticleCollectionVecInput m_vecTailColorScale; // = { "m_LiteralColor": [ 255, 255, 255 ], "m_nType": "PVEC_TYPE_LITERAL_COLOR" }
	// MPropertyFriendlyName = "tail alpha scale"
	CPerParticleFloatInput m_flTailAlphaScale; // = { "m_flLiteralValue": 1 }
	// MPropertyStartGroup = "Trail UV Controls"
	// MPropertyFriendlyName = "texture UV horizontal Scale field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	// MPropertySortPriority = 800
	ParticleAttributeIndex_t m_nHorizCropField; // = 19
	// MPropertyFriendlyName = "texture UV vertical Scale field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nVertCropField; // = 19
	// MPropertyFriendlyName = "Trail forward shift (fraction)"
	float32 m_flForwardShift;
	// MPropertyFriendlyName = "Flip U or V texcoords if pitch or yaw go over PI"
	bool m_bFlipUVBasedOnPitchYaw;
};
