// MHasKV3TransferPolymorphicClassname
class C_OP_DragRelativeToPlane : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "dampening"
	CParticleCollectionFloatInput m_flDragAtPlane;
	// MPropertyFriendlyName = "falloff"
	CParticleCollectionFloatInput m_flFalloff; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "dampen on only one side of plane"
	bool m_bDirectional;
	// MPropertyFriendlyName = "plane normal"
	// MVectorIsCoordinate
	CParticleCollectionVecInput m_vecPlaneNormal; // = { "m_vLiteralValue": [ 0, 0, 1 ] }
	// MPropertyFriendlyName = "control point number"
	int32 m_nControlPointNumber;
};
