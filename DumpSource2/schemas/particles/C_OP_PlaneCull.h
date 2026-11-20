// MHasKV3TransferPolymorphicClassname
class C_OP_PlaneCull : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "control point for point on plane"
	int32 m_nPlaneControlPoint;
	// MPropertyFriendlyName = "plane normal"
	CParticleCollectionVecInput m_vecPlaneDirection; // = { "m_vLiteralValue": [ 0, 0, 1 ] }
	// MPropertyFriendlyName = "use local space"
	bool m_bLocalSpace;
	// MPropertyFriendlyName = "cull plane offset"
	float32 m_flPlaneOffset;
};
