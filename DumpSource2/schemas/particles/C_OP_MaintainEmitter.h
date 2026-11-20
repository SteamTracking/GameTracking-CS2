// MHasKV3TransferPolymorphicClassname
class C_OP_MaintainEmitter : public CParticleFunctionEmitter
{
	// MPropertyFriendlyName = "count to maintain"
	CParticleCollectionFloatInput m_nParticlesToMaintain; // = { "m_flLiteralValue": 100 }
	// MPropertyFriendlyName = "emission start time"
	float32 m_flStartTime;
	// MPropertyFriendlyName = "emission duration"
	CParticleCollectionFloatInput m_flEmissionDuration;
	// MPropertyFriendlyName = "emission rate"
	float32 m_flEmissionRate; // = -1
	// MPropertyFriendlyName = "control point with snapshot data"
	int32 m_nSnapshotControlPoint; // = -1
	// MPropertyFriendlyName = "snapshot subset"
	// MPropertySuppressExpr = "m_nSnapshotControlPoint < 0"
	CUtlString m_strSnapshotSubset;
	// MPropertyFriendlyName = "group emission times for new particles"
	bool m_bEmitInstantaneously;
	// MPropertyFriendlyName = "perform final emit on stop"
	bool m_bFinalEmitOnStop;
	// MPropertyFriendlyName = "total count scale"
	CParticleCollectionFloatInput m_flScale; // = { "m_flLiteralValue": 1 }
};
