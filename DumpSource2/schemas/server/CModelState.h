// MHasKV3TransferPolymorphicClassname
class CModelState
{
	CStrongHandle< InfoForResourceTypeCModel > m_hModel;
	CUtlSymbolLarge m_ModelName;
	// MPhysPtr
	IPhysAggregateInstance* m_pVPhysicsAggregate;
	float32 m_flRootBoneOffset_x;
	float32 m_flRootBoneOffset_y;
	float32 m_flRootBoneOffset_z;
	uint8 m_nRootBoneOffsetResetSerialNumber;
	bool m_bClientClothCreationSuppressed;
	uint8 m_nAnimStateNoInterpSerialNumber;
	uint64 m_MeshGroupMask;
	CNetworkUtlVectorBase< int32 > m_nBodyGroupChoices;
	int8 m_nIdealMotionType;
	int8 m_nForceLOD;
	int8 m_nClothUpdateFlags;
};
