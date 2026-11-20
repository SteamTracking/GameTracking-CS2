// MHasKV3TransferPolymorphicClassname
class CLookComponentUpdater : public CAnimComponentUpdater
{
	CAnimParamHandle m_hLookHeading;
	CAnimParamHandle m_hLookHeadingNormalized;
	CAnimParamHandle m_hLookHeadingVelocity;
	CAnimParamHandle m_hLookPitch;
	CAnimParamHandle m_hLookDistance;
	CAnimParamHandle m_hLookDirection;
	CAnimParamHandle m_hLookTarget;
	CAnimParamHandle m_hLookTargetWorldSpace;
	bool m_bNetworkLookTarget; // = true
};
