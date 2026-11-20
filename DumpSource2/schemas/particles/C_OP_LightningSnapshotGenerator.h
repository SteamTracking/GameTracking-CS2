// MHasKV3TransferPolymorphicClassname
class C_OP_LightningSnapshotGenerator : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "snapshot control point number"
	int32 m_nCPSnapshot;
	// MPropertyFriendlyName = "start control point number"
	int32 m_nCPStartPnt;
	// MPropertyFriendlyName = "end control point number"
	int32 m_nCPEndPnt; // = 1
	// MPropertyFriendlyName = "Recursion Depth"
	CParticleCollectionFloatInput m_flSegments; // = { "m_flLiteralValue": 4 }
	// MPropertyFriendlyName = "Offset"
	CParticleCollectionFloatInput m_flOffset; // = { "m_flLiteralValue": 32 }
	// MPropertyFriendlyName = "Offset Decay"
	CParticleCollectionFloatInput m_flOffsetDecay; // = { "m_flLiteralValue": 0.5 }
	// MPropertyFriendlyName = "Recalculation Rate"
	CParticleCollectionFloatInput m_flRecalcRate; // = { "m_flLiteralValue": -1 }
	// MPropertyFriendlyName = "UV Scale"
	CParticleCollectionFloatInput m_flUVScale; // = { "m_flLiteralValue": 100 }
	// MPropertyFriendlyName = "UV Offset"
	CParticleCollectionFloatInput m_flUVOffset;
	// MPropertyFriendlyName = "Branch Split Rate"
	CParticleCollectionFloatInput m_flSplitRate; // = { "m_flLiteralValue": 0.25 }
	// MPropertyFriendlyName = "Recursion Branch Split Scale"
	CParticleCollectionFloatInput m_flRecursionSplitScale; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "Scale Branch Distance From Recursion Depth"
	bool m_bScaleBranchDistance;
	// MPropertyFriendlyName = "Branch Recursion Distance Scale Factor"
	// MPropertySuppressExpr = "m_bScaleBranchDistance == false"
	CParticleCollectionFloatInput m_flBranchDistanceScale; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "Scale Branch Offset/Twist From Recursion Depth"
	bool m_bScaleBranchOffset;
	// MPropertyFriendlyName = "Branch Recursion Offset/Twist Scale Factor"
	// MPropertySuppressExpr = "m_bScaleBranchOffset == false"
	CParticleCollectionFloatInput m_flBranchOffsetScale; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "Branch Twist"
	CParticleCollectionFloatInput m_flBranchTwist; // = { "m_flLiteralValue": 0.5 }
	// MPropertyFriendlyName = "Branch Behavior"
	ParticleLightnintBranchBehavior_t m_nBranchBehavior; // = "PARTICLE_LIGHTNING_BRANCH_CURRENT_DIR"
	// MPropertyFriendlyName = "Start Radius"
	CParticleCollectionFloatInput m_flRadiusStart; // = { "m_flLiteralValue": 10 }
	// MPropertyFriendlyName = "End Radius"
	CParticleCollectionFloatInput m_flRadiusEnd;
	// MPropertyFriendlyName = "Dedicated Particle Pool Count"
	CParticleCollectionFloatInput m_flDedicatedPool; // = { "m_flLiteralValue": -1 }
};
