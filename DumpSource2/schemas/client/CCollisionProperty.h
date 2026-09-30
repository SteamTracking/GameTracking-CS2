// MHasKV3TransferPolymorphicClassname
class CCollisionProperty
{
	VPhysicsCollisionAttribute_t m_collisionAttribute; // = { "m_nCollisionFunctionMask": 7, "m_nCollisionGroup": 4, "m_nDetailLayerMask": 0, "m_nDetailLayerMaskType": 0, "m_nEntityId": 0, "m_nHierarchyId": 0, "m_nInteractsAs": 131072, "m_nInteractsExclude": 0, "m_nInteractsWith": 0, "m_nOwnerId": 4294967295, "m_nTargetDetailLayer": 0 }
	// MSaveBehavior = 1
	Vector m_vecMins;
	// MSaveBehavior = 1
	Vector m_vecMaxs;
	uint8 m_usSolidFlags;
	SolidType_t m_nSolidType; // = "SOLID_NONE"
	uint8 m_triggerBloat;
	SurroundingBoundsType_t m_nSurroundType; // = "USE_OBB_COLLISION_BOUNDS"
	uint8 m_CollisionGroup; // = 4
	uint8 m_nEnablePhysics; // = 1
	float32 m_flBoundingRadius;
	Vector m_vecSpecifiedSurroundingMins;
	Vector m_vecSpecifiedSurroundingMaxs;
	Vector m_vecSurroundingMaxs;
	Vector m_vecSurroundingMins;
	Vector m_vCapsuleCenter1;
	Vector m_vCapsuleCenter2;
	float32 m_flCapsuleRadius;
};
