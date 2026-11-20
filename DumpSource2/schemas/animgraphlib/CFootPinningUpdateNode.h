// MHasKV3TransferPolymorphicClassname
class CFootPinningUpdateNode : public CUnaryUpdateNode
{
	FootPinningPoseOpFixedData_t m_poseOpFixedData;
	FootPinningTimingSource m_eTimingSource; // = "FootMotion"
	CUtlVector< CAnimParamHandle > m_params;
	bool m_bResetChild;
};
