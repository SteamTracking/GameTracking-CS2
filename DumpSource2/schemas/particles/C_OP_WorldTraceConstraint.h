// MGPUParticleFunction
// MHasKV3TransferPolymorphicClassname
class C_OP_WorldTraceConstraint : public CParticleFunctionConstraint
{
	// MPropertyFriendlyName = "control point for fast collision tests"
	int32 m_nCP;
	// MPropertyFriendlyName = "control point offset for fast collisions"
	// MVectorIsCoordinate
	Vector m_vecCpOffset;
	// MPropertyFriendlyName = "collision mode"
	ParticleCollisionMode_t m_nCollisionMode; // = "COLLISION_MODE_PER_PARTICLE_TRACE"
	// MPropertyFriendlyName = "minimum detail collision mode"
	ParticleCollisionMode_t m_nCollisionModeMin; // = "COLLISION_MODE_DISABLED"
	// MPropertyStartGroup = "Collision Options"
	// MPropertyFriendlyName = "Trace Set"
	ParticleTraceSet_t m_nTraceSet; // = "PARTICLE_TRACE_SET_ALL"
	// MPropertyFriendlyName = "collision group"
	char[128] m_CollisionGroupName; // = "NONE"
	// MPropertyFriendlyName = "World Only"
	bool m_bWorldOnly;
	// MPropertyFriendlyName = "brush only"
	bool m_bBrushOnly;
	// MPropertyFriendlyName = "include water"
	// MPropertySuppressExpr = "m_nTraceSet == PARTICLE_TRACE_SET_STATIC"
	bool m_bIncludeWater;
	// MPropertyFriendlyName = "CP Entity to Ignore for Collisions"
	// MPropertySuppressExpr = "m_nTraceSet == PARTICLE_TRACE_SET_STATIC"
	int32 m_nIgnoreCP; // = -1
	// MPropertyFriendlyName = "control point movement distance tolerance"
	// MPropertySuppressExpr = "m_nCollisionMode == COLLISION_MODE_PER_PARTICLE_TRACE"
	float32 m_flCpMovementTolerance; // = 5
	// MPropertyFriendlyName = "plane cache retest rate"
	// MPropertySuppressExpr = "m_nCollisionMode != COLLISION_MODE_PER_FRAME_PLANESET"
	float32 m_flRetestRate; // = -1
	// MPropertyFriendlyName = "trace accuracy tolerance"
	// MPropertySuppressExpr = "m_nCollisionMode != COLLISION_MODE_USE_NEAREST_TRACE"
	float32 m_flTraceTolerance; // = 24
	// MPropertyFriendlyName = "Confirm Collision Speed Threshold"
	// MPropertySuppressExpr = "m_nCollisionMode == COLLISION_MODE_PER_PARTICLE_TRACE"
	float32 m_flCollisionConfirmationSpeed; // = 24
	// MPropertyFriendlyName = "Max Confirmation Traces Per Fame"
	// MPropertySuppressExpr = "m_nCollisionMode == COLLISION_MODE_PER_PARTICLE_TRACE"
	float32 m_nMaxTracesPerFrame; // = -1
	// MPropertyStartGroup = "Impact Options"
	// MPropertyFriendlyName = "radius scale"
	CPerParticleFloatInput m_flRadiusScale; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "amount of bounce"
	CPerParticleFloatInput m_flBounceAmount;
	// MPropertyFriendlyName = "amount of slide"
	CPerParticleFloatInput m_flSlideAmount;
	// MPropertyFriendlyName = "Random Direction scale"
	CPerParticleFloatInput m_flRandomDirScale;
	// MPropertyFriendlyName = "Add Decay to Bounce"
	bool m_bDecayBounce;
	// MPropertyFriendlyName = "kill particle on collision"
	bool m_bKillonContact;
	// MPropertyFriendlyName = "minimum speed to kill on collision"
	float32 m_flMinSpeed; // = -1
	// MPropertyFriendlyName = "calculate bounce on killed particles (for child events)"
	// MPropertySuppressExpr = "m_bKillonContact == false"
	bool m_bKillonContactBounce;
	// MPropertyFriendlyName = "Set Normal"
	bool m_bSetNormal;
	// MPropertyFriendlyName = "Stick On Collision Cache Field"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nStickOnCollisionField; // = 19
	// MPropertyFriendlyName = "Speed to stop when sticking"
	CPerParticleFloatInput m_flStopSpeed; // = { "m_flLiteralValue": -1 }
	// MPropertyFriendlyName = "Entity Hitbox Cache Field (Requires Stick on Collision)"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nEntityStickDataField; // = 19
	// MPropertyFriendlyName = "Entity Normal Cache Field (Requires Stick on Collision)"
	// MPropertyAttributeChoiceName = "particlefield_vector"
	ParticleAttributeIndex_t m_nEntityStickNormalField; // = 19
};
