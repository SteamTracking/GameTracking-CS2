// MPropertyFriendlyName = "Occlusion Info"
// MHasKV3TransferPolymorphicClassname
class CSosGroupActionOcclusionSchema : public CSosGroupActionSchema
{
	// MPropertyFriendlyName = "Calculation interval ( seconds )."
	float32 m_flCalculationInterval; // = 0.1
	// MPropertyFriendlyName = "Occlusion radius."
	float32 m_flRadius;
	// MPropertyFriendlyName = "Occlusion scale."
	float32 m_flOcclusionScale; // = 1
	// MPropertyFriendlyName = "Occlusion min."
	float32 m_flOcclusionMin;
	// MPropertyFriendlyName = "Occlusion max."
	float32 m_flOcclusionMax; // = 1
	// MPropertyFriendlyName = "Test depth."
	float32 m_flTestDepth;
};
