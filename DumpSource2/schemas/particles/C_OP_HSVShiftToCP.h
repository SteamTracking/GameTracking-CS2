// MHasKV3TransferPolymorphicClassname
class C_OP_HSVShiftToCP : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "Target color control point number"
	int32 m_nColorCP; // = 60
	// MPropertyFriendlyName = "Color Gem Enable control point number"
	int32 m_nColorGemEnableCP; // = 61
	// MPropertyFriendlyName = "output control point number"
	int32 m_nOutputCP; // = 62
	// MPropertyFriendlyName = "Default HSV Color"
	Color m_DefaultHSVColor; // = [ 255, 255, 255 ]
};
