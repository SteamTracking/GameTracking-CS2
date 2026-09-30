// MPropertyFriendlyName = "Filter: Surface Angles"
// MPropertyDescription = "Allows the parent element to be conditionally evaluated base on the current surface angle. The surface angle is set based on the initial placement of the smart prop object, but can also be updated by the Trace to Surface modifier."
// MVDataClassGroup = "Filter"
// MHasKV3TransferPolymorphicClassname
class CSmartPropFilter_SurfaceAngle : public CSmartPropFilter
{
	// MPropertyDescription = "Minimum slope on which the target will be placed. Slope is a [ 0, 180 ] value of the surface normal rotation from up such that 0 is a horizontal surface (floor), 90 is a vertical surface (wall), 180 is horizontal upside down surface (ceiling)."
	CSmartPropAttributeFloat m_flSurfaceSlopeMin;
	// MPropertyDescription = "Maximum slope on which the target will be placed."
	CSmartPropAttributeFloat m_flSurfaceSlopeMax; // = 180
};
