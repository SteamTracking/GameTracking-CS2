// MHasKV3TransferPolymorphicClassname
class CNmAimCSNode::CDefinition : public CNmPassthroughNode::CDefinition
{
	int16 m_nVerticalAngleNodeIdx; // = -1
	int16 m_nHorizontalAngleNodeIdx; // = -1
	int16 m_nWeaponCategoryNodeIdx; // = -1
	int16 m_nWeaponTypeNodeIdx; // = -1
	int16 m_nWeaponActionNodeIdx; // = -1
	int16 m_nWeaponDropNodeIdx; // = -1
	int16 m_nIsDefusingNodeIdx; // = -1
	int16 m_nCrouchWeightNodeIdx; // = -1
	float32 m_flHandIKBlendInTimeSeconds;
	float32 m_flActionBlendTimeSeconds;
	float32 m_flPlantingBlendTimeSeconds;
};
