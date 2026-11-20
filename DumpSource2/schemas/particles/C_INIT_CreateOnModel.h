// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_INIT_CreateOnModel : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "input model"
	CParticleModelInput m_modelInput; // = { "m_nControlPoint": 0, "m_nType": "PM_TYPE_CONTROL_POINT" }
	// MPropertyFriendlyName = "input transform for transforming local space bias vector"
	// MParticleInputOptional
	CParticleTransformInput m_transformInput;
	// MPropertyFriendlyName = "force to be inside model"
	// MPropertySuppressExpr = "is_gpu_particle_system"
	int32 m_nForceInModel;
	// MPropertyFriendlyName = "bias box distribution by volume"
	bool m_bScaleToVolume;
	// MPropertyFriendlyName = "even distribution within boxes"
	bool m_bEvenDistribution;
	// MPropertyFriendlyName = "desired hitbox"
	CParticleCollectionFloatInput m_nDesiredHitbox; // = { "m_flLiteralValue": -1 }
	// MPropertyFriendlyName = "Control Point Providing Hitbox index"
	int32 m_nHitboxValueFromControlPointIndex; // = -1
	// MPropertyFriendlyName = "hitbox scale"
	CParticleCollectionVecInput m_vecHitBoxScale; // = { "m_vLiteralValue": [ 1, 1, 1 ] }
	// MPropertyFriendlyName = "inherited velocity scale"
	float32 m_flBoneVelocity;
	// MPropertyFriendlyName = "maximum inherited velocity"
	float32 m_flMaxBoneVelocity;
	// MPropertyFriendlyName = "direction bias"
	// MVectorIsCoordinate
	// MPropertySuppressExpr = "is_gpu_particle_system"
	CParticleCollectionVecInput m_vecDirectionBias;
	// MPropertyFriendlyName = "hitbox set"
	char[128] m_HitboxSetName; // = "default"
	// MPropertyFriendlyName = "bias in local space"
	bool m_bLocalCoords;
	// MPropertyFriendlyName = "use bones instead of hitboxes"
	// MPropertySuppressExpr = "is_gpu_particle_system"
	bool m_bUseBones;
	// MPropertyFriendlyName = "Use renderable meshes instead of hitboxes"
	// MPropertySuppressExpr = "is_gpu_particle_system"
	bool m_bUseMesh;
	// MPropertyFriendlyName = "hitbox shell thickness"
	// MPropertySuppressExpr = "is_gpu_particle_system"
	CParticleCollectionFloatInput m_flShellSize; // = { "m_flLiteralValue": 1 }
};
