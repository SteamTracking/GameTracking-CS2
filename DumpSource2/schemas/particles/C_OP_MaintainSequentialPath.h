// MHasKV3TransferPolymorphicClassname
class C_OP_MaintainSequentialPath : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "maximum distance"
	CParticleCollectionFloatInput m_fMaxDistance;
	// MPropertyFriendlyName = "particles to map from start to end"
	CParticleCollectionFloatInput m_flNumToAssign; // = { "m_flLiteralValue": 100 }
	// MPropertyFriendlyName = "cohesion strength"
	CParticleCollectionFloatInput m_flCohesionStrength; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "control point movement tolerance"
	float32 m_flTolerance;
	// MPropertyFriendlyName = "restart behavior (0 = bounce, 1 = loop )"
	bool m_bLoop; // = true
	// MPropertyFriendlyName = "use existing particle count"
	bool m_bUseParticleCount;
	CPathParameters m_PathParams;
};
