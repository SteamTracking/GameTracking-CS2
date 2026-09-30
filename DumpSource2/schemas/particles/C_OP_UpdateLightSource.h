// MHasKV3TransferPolymorphicClassname
class C_OP_UpdateLightSource : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "color tint"
	Color m_vColorTint; // = [ 255, 255, 255 ]
	// MPropertyFriendlyName = "amount to multiply light brightness by"
	float32 m_flBrightnessScale; // = 1
	// MPropertyFriendlyName = "amount to multiply particle system radius by to get light radius"
	float32 m_flRadiusScale; // = 4
	// MPropertyFriendlyName = "minimum radius for created lights"
	float32 m_flMinimumLightingRadius;
	// MPropertyFriendlyName = "maximum radius for created lights"
	float32 m_flMaximumLightingRadius; // = 100000
	// MPropertyFriendlyName = "amount of damping of changes"
	float32 m_flPositionDampingConstant; // = 0.1
};
