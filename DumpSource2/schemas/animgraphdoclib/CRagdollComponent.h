// MHasKV3TransferPolymorphicClassname
class CRagdollComponent : public CAnimGraphDoc_Component
{
	CUtlVector< CAnimGraphDoc_RigidBodyWeightList > m_weightLists;
	float32 m_flSpringFrequencyMin;
	float32 m_flSpringFrequencyMax; // = 15
	float32 m_flMaxStretch; // = 56
	bool m_bSolidCollisionAtZeroWeight;
};
