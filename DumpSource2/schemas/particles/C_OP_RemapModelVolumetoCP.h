// MHasKV3TransferPolymorphicClassname
class C_OP_RemapModelVolumetoCP : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "output BBox Type"
	BBoxVolumeType_t m_nBBoxType; // = "BBOX_VOLUME"
	// MPropertyFriendlyName = "input control point"
	int32 m_nInControlPointNumber;
	// MPropertyFriendlyName = "output control point"
	int32 m_nOutControlPointNumber; // = -1
	// MPropertyFriendlyName = "output max control point"
	// MPropertySuppressExpr = "m_nBBoxType != BBOX_MINS_MAXS"
	int32 m_nOutControlPointMaxNumber; // = -1
	// MPropertyFriendlyName = "output CP component"
	// MPropertyAttributeChoiceName = "vector_component"
	// MPropertySuppressExpr = "m_nBBoxType != BBOX_VOLUME && m_nBBoxType != BBOX_RADIUS"
	int32 m_nField;
	// MPropertyFriendlyName = "input volume minimum"
	// MPropertySuppressExpr = "m_nBBoxType != BBOX_VOLUME && m_nBBoxType != BBOX_RADIUS && m_nBBoxType != BBOX_SURFACE_AREA"
	float32 m_flInputMin;
	// MPropertyFriendlyName = "input volume maximum"
	// MPropertySuppressExpr = "m_nBBoxType != BBOX_VOLUME && m_nBBoxType != BBOX_RADIUS && m_nBBoxType != BBOX_SURFACE_AREA"
	float32 m_flInputMax; // = 128
	// MPropertyFriendlyName = "output minimum"
	// MPropertySuppressExpr = "m_nBBoxType != BBOX_VOLUME && m_nBBoxType != BBOX_RADIUS && m_nBBoxType != BBOX_SURFACE_AREA"
	float32 m_flOutputMin;
	// MPropertyFriendlyName = "output maximum"
	// MPropertySuppressExpr = "m_nBBoxType != BBOX_VOLUME && m_nBBoxType != BBOX_RADIUS && m_nBBoxType != BBOX_SURFACE_AREA"
	float32 m_flOutputMax; // = 1
	// MPropertyFriendlyName = "check full bbox only"
	// MPropertySuppressExpr = "m_nBBoxType != BBOX_VOLUME"
	bool m_bBBoxOnly; // = true
	// MPropertyFriendlyName = "cube root of volume"
	// MPropertySuppressExpr = "m_nBBoxType != BBOX_VOLUME"
	bool m_bCubeRoot; // = true
};
