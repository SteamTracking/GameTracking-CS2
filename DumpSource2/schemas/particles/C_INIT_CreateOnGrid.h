// MHasKV3TransferPolymorphicClassname
class C_INIT_CreateOnGrid : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "X Dimension Count"
	CParticleCollectionFloatInput m_nXCount;
	// MPropertyFriendlyName = "Y Dimension Count"
	CParticleCollectionFloatInput m_nYCount;
	// MPropertyFriendlyName = "Z Dimension Count"
	CParticleCollectionFloatInput m_nZCount;
	// MPropertyFriendlyName = "X Dimension Spacing"
	CParticleCollectionFloatInput m_nXSpacing;
	// MPropertyFriendlyName = "Y Dimension Spacing"
	CParticleCollectionFloatInput m_nYSpacing;
	// MPropertyFriendlyName = "Z Dimension Spacing"
	CParticleCollectionFloatInput m_nZSpacing;
	// MPropertyFriendlyName = "control point number"
	int32 m_nControlPointNumber;
	// MPropertyFriendlyName = "use local space"
	bool m_bLocalSpace; // = true
	// MPropertyFriendlyName = "center around control point"
	bool m_bCenter; // = true
	// MPropertyFriendlyName = "hollow"
	bool m_bHollow;
};
