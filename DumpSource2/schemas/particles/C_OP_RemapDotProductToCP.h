// MHasKV3TransferPolymorphicClassname
class C_OP_RemapDotProductToCP : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "first input control point"
	int32 m_nInputCP1;
	// MPropertyFriendlyName = "second input control point"
	int32 m_nInputCP2; // = 1
	// MPropertyFriendlyName = "output control point"
	int32 m_nOutputCP; // = 2
	// MPropertyFriendlyName = "output component"
	// MPropertyAttributeChoiceName = "vector_component"
	int32 m_nOutVectorField;
	// MPropertyFriendlyName = "input minimum (-1 to 1)"
	CParticleCollectionFloatInput m_flInputMin;
	// MPropertyFriendlyName = "input maximum (-1 to 1)"
	CParticleCollectionFloatInput m_flInputMax; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "output minimum"
	CParticleCollectionFloatInput m_flOutputMin;
	// MPropertyFriendlyName = "output maximum"
	CParticleCollectionFloatInput m_flOutputMax; // = { "m_flLiteralValue": 1 }
};
