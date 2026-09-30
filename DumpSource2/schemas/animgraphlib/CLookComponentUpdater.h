// MHasKV3TransferPolymorphicClassname
class CLookComponentUpdater : public CAnimComponentUpdater
{
	CAnimParamHandle m_hLookHeading; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	CAnimParamHandle m_hLookHeadingNormalized; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	CAnimParamHandle m_hLookHeadingVelocity; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	CAnimParamHandle m_hLookPitch; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	CAnimParamHandle m_hLookDistance; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	CAnimParamHandle m_hLookDirection; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	CAnimParamHandle m_hLookTarget; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	CAnimParamHandle m_hLookTargetWorldSpace; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	bool m_bNetworkLookTarget; // = true
};
