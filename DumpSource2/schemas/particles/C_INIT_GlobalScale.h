// MHasKV3TransferPolymorphicClassname
class C_INIT_GlobalScale : public CParticleFunctionInitializer
{
	// MPropertyFriendlyName = "scale amount"
	float32 m_flScale; // = 1
	// MPropertyFriendlyName = "scale control point number"
	int32 m_nScaleControlPointNumber; // = -1
	// MPropertyFriendlyName = "control point number"
	int32 m_nControlPointNumber;
	// MPropertyFriendlyName = "scale radius"
	bool m_bScaleRadius; // = true
	// MPropertyFriendlyName = "scale position"
	bool m_bScalePosition; // = true
	// MPropertyFriendlyName = "scale velocity"
	bool m_bScaleVelocity; // = true
};
