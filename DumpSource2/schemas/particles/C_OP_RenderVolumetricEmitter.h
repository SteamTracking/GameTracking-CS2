// MHasKV3TransferPolymorphicClassname
class C_OP_RenderVolumetricEmitter : public CParticleFunctionRenderer
{
	// MPropertyFriendlyName = "channel type"
	// MPropertyAttributeEditor = "VDataChoice( scripts/volumetric_channels.vdata )"
	// MPropertySuppressExpr = "m_nType != PARTICLE_VOLUMETRIC_SMOKE_TYPE_EMISSION"
	CUtlString m_strChannelType; // = "default"
	// MPropertyFriendlyName = "interaction type"
	ParticleVolumetricSmokeType_t m_nType; // = "PARTICLE_VOLUMETRIC_SMOKE_TYPE_EMISSION"
	// MPropertyFriendlyName = "creation type"
	ParticleVolumetricSmokeCreationType_t m_nCreationType; // = "PARTICLE_VOLUMETRIC_SMOKE_TYPE_CONTINUOUS"
	// MPropertyFriendlyName = "event type"
	// MPropertySuppressExpr = "m_nCreationType == PARTICLE_VOLUMETRIC_SMOKE_TYPE_CONTINUOUS"
	EventTypeSelection_t m_nEventType; // = "PARTICLE_EVENT_TYPE_MASK_SPAWNED"
	// MPropertyFriendlyName = "position"
	CPerParticleVecInput m_vecPos; // = { "m_nType": "PVEC_TYPE_PARTICLE_VECTOR", "m_nVectorAttribute": 0 }
	// MPropertyFriendlyName = "velocity"
	// MPropertySuppressExpr = "m_nType != PARTICLE_VOLUMETRIC_SMOKE_TYPE_EMISSION"
	CPerParticleVecInput m_vecVelocity; // = { "m_nType": "PVEC_TYPE_PARTICLE_VECTOR", "m_nVectorAttribute": 2 }
	// MPropertyFriendlyName = "prev position"
	// MPropertySuppressExpr = "m_nType != PARTICLE_VOLUMETRIC_SMOKE_TYPE_TRACE"
	CPerParticleVecInput m_vPrevPosition; // = { "m_nType": "PVEC_TYPE_PARTICLE_VECTOR", "m_nVectorAttribute": 2 }
	// MPropertyFriendlyName = "speed"
	// MPropertySuppressExpr = "m_nType != PARTICLE_VOLUMETRIC_SMOKE_TYPE_TRACE"
	CPerParticleFloatInput m_flSpeed; // = { "m_nScalarAttribute": 7, "m_nType": "PF_TYPE_PARTICLE_FLOAT" }
	// MPropertyFriendlyName = "radius"
	CPerParticleFloatInput m_flRadius; // = { "m_nType": "PF_TYPE_PARTICLE_FLOAT" }
	// MPropertyFriendlyName = "density"
	// MPropertySuppressExpr = "m_nType == PARTICLE_VOLUMETRIC_SMOKE_TYPE_TRACE"
	CPerParticleFloatInput m_flDensity; // = { "m_nScalarAttribute": 7, "m_nType": "PF_TYPE_PARTICLE_FLOAT" }
	// MPropertyFriendlyName = "temperature"
	// MPropertySuppressExpr = "m_nType == PARTICLE_VOLUMETRIC_SMOKE_TYPE_TRACE"
	CPerParticleFloatInput m_flTemperature; // = { "m_flLiteralValue": -1 }
	// MPropertyFriendlyName = "magnitude"
	// MPropertySuppressExpr = "m_nType == PARTICLE_VOLUMETRIC_SMOKE_TYPE_EMISSION || m_nType == PARTICLE_VOLUMETRIC_SMOKE_TYPE_TRACE"
	CPerParticleFloatInput m_flMagnitude; // = { "m_flLiteralValue": -1 }
	// MPropertyFriendlyName = "kill radius"
	// MPropertySuppressExpr = "m_nType == PARTICLE_VOLUMETRIC_SMOKE_TYPE_EMISSION"
	CPerParticleFloatInput m_flKillRadius; // = { "m_flLiteralValue": -1 }
	// MPropertyFriendlyName = "kill density scale"
	// MPropertySuppressExpr = "m_nType == PARTICLE_VOLUMETRIC_SMOKE_TYPE_EMISSION"
	CPerParticleFloatInput m_flKillDensityScale; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "falloff"
	// MPropertySuppressExpr = "m_nType == PARTICLE_VOLUMETRIC_SMOKE_TYPE_EMISSION"
	CPerParticleFloatInput m_flFalloff; // = { "m_flLiteralValue": -1 }
};
