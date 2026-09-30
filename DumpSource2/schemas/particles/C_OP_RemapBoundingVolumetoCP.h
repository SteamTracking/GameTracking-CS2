// MHasKV3TransferPolymorphicClassname
class C_OP_RemapBoundingVolumetoCP : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "output control point"
	int32 m_nOutControlPointNumber; // = -1
	// MPropertyFriendlyName = "input volume minimum in cubic units"
	float32 m_flInputMin;
	// MPropertyFriendlyName = "input volume maximum in cubic units"
	float32 m_flInputMax; // = 128
	// MPropertyFriendlyName = "output minimum"
	float32 m_flOutputMin;
	// MPropertyFriendlyName = "output maximum"
	float32 m_flOutputMax; // = 1
};
