// MPropertyFriendlyName = "Bone Transforms"
// MHasKV3TransferPolymorphicClassname
class DebugDrawBoneTransforms_t : public DebugSnapshotBaseStructuredData_t
{
	CUtlVectorFixedGrowable< CTransform, 128 > vecBones;
};
