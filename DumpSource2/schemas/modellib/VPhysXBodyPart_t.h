class VPhysXBodyPart_t
{
	uint32 m_nFlags;
	float32 m_flMass;
	VPhysics2ShapeDef_t m_rnShape;
	uint16 m_nCollisionAttributeIndex;
	uint16 m_nReserved;
	float32 m_flInertiaScale;
	float32 m_flLinearDamping;
	float32 m_flAngularDamping;
	float32 m_flLinearDrag; // = 1
	float32 m_flAngularDrag; // = 1
	bool m_bOverrideMassCenter;
	Vector m_vMassCenterOverride;
};
