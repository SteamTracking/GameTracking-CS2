// MHasKV3TransferPolymorphicClassname
class C_OP_ModelSurfaceSnapshotGenerator : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "snapshot control point number"
	int32 m_nCPSnapshot;
	// MPropertyFriendlyName = "input model"
	CParticleModelInput m_modelInput; // = { "m_nControlPoint": 0, "m_nType": "PM_TYPE_CONTROL_POINT" }
	// MPropertyFriendlyName = "Recalculation Rate"
	CParticleCollectionFloatInput m_flRecalcRate; // = { "m_flLiteralValue": -1 }
	// MPropertyFriendlyName = "U Spacing"
	CParticleCollectionFloatInput m_flUSpacing; // = { "m_flLiteralValue": 0.25 }
	// MPropertyFriendlyName = "V Spacing"
	CParticleCollectionFloatInput m_flVSpacing; // = { "m_flLiteralValue": 0.25 }
	// MPropertyFriendlyName = "Surface Offset"
	CParticleCollectionFloatInput m_flSurfaceOffset;
	// MPropertyFriendlyName = "Set Normal"
	bool m_bSetNormal; // = true
	// MPropertyFriendlyName = "Set UV Up Direction (To Box Angles)"
	bool m_bSetUp;
	// MPropertyFriendlyName = "Set Gravity Direction (To Prev Position)"
	bool m_bSetGravity;
	// MPropertyFriendlyName = "Set UV (To Hitbox Offset)"
	bool m_bSetUV;
};
