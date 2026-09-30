// MPropertyFriendlyName = "Model"
// MVDataAnonymousNode
// MVDataOutlinerAssetNameExpr = "m_ModelName"
class CDetailPropModel
{
	// MPropertyDescription = "Model to be displayed."
	// MPropertyProvidesEditContextString = "ToolEditContext_ID_VMDL"
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeCModel > > m_ModelName;
	// MPropertyDescription = "Material group (skin) to assign to use with the model."
	CModelMaterialGroupName m_MaterialGroup;
	// MPropertyDescription = "A weight determining the frequency at which this model is placed relative to other models within the detail type. The weights of all models are summed and the probability of selecting this model is its weight divided by the sum weight."
	float32 m_flWeight; // = 1
	// MPropertyAttributeRange = "0.001 1.0"
	// MPropertyFriendlyName = "Start fade out size"
	// MPropertyDescription = "Screen space size [ 0, 1 ] (where 1 is the whole screen) at which the model will begin to to fade out. Anything larger will be fully visible, anything smaller will start to fade out."
	float32 m_flStartFadeSize; // = 0.02
	// MPropertyAttributeRange = "0.001 1.0"
	// MPropertyFriendlyName = "Complete fade out size"
	// MPropertyDescription = "Screen space size [ 0, 1 ] (where 1 is the whole screen) at which the model will be completely faded out. Anything smaller than this size will not be visible, anything larger will start fading in."
	float32 m_flEndFadeSize; // = 0.0125
	// MPropertyFriendlyName = "Use World Space Up"
	// MPropertyDescription = "If enabled, the up direction will be evaluated in world space, such that the object orientation does not affect the surface slope filtering. Additionally if Orient To Surface is 0, then and world space up is enabled, then the object orientation will not affect the rotation of detail model."
	bool m_bWorldSpaceOrientation;
	// MPropertyAttributeRange = "0.0 1.0"
	// MPropertyDescription = "Value indicating if the model's up direction should be matched to the surface. Value should be in the [ 0, 1 ] range, where 0 means that the model up will be model (or object space) up and will ignore the surface direction, and 1 indicates that the model up will exactly match the surface normal."
	float32 m_flOrientToSurface; // = 1
	// MPropertyAttributeRange = "0.0 180.0"
	// MPropertyDescription = "Minimum slope on which the target will be placed. Slope is a [ 0, 180 ] value based on the surface normal where horizontal surface (floor) is 0, vertical surface (wall) is 90, and a horizontal upside down surface (ceiling) is 180."
	float32 m_flMinSurfaceSlope;
	// MPropertyAttributeRange = "0.0 180.0"
	// MPropertyDescription = "Maximum slope on which the target will be placed."
	float32 m_flMaxSurfaceSlope; // = 180
	// MPropertyDescription = "Minimum range of random offset to apply along the model's local up direction"
	float32 m_flRandomVerticalOffsetMin;
	// MPropertyDescription = "Maximum range of random offset to apply along the model's local up direction"
	float32 m_flRandomVerticalOffsetMax;
	// MPropertyDescription = "Minimum range of the random rotation to apply the model. Random rotation is applied in the local space of the model. Rotation values are ordered pitch, yaw, roll."
	QAngle m_vRandomRotationMin;
	// MPropertyDescription = "Maximum range of the random rotation to apply the model."
	QAngle m_vRandomRotationMax; // = [ 0, 360, 0 ]
	// MPropertyDescription = "Minimum random scale value to apply to the model."
	float32 m_flRandomScaleMin; // = 1
	// MPropertyDescription = "Maximum random scale value to apply to the model."
	float32 m_flRandomScaleMax; // = 1
	// MPropertyFriendlyName = "Density Scale"
	// MPropertyAttributeRange = "0.01 1.0"
	// MPropertyDescription = "Minimum scale to apply to the model based the painted detail prop density. The minimum of the detail and blend weight scale values is multiplied with the random scale value to determine the final scale."
	float32 m_flDensityMinScale; // = 1
	// MPropertyFriendlyName = "Blend Weight Scale"
	// MPropertyAttributeRange = "0.01 1.0"
	// MPropertyDescription = "Minimum scale to apply to the model based on the final material layer blend weight. The model will be given this scale value when the layer blend weight equals the minimum blend weight and will be 1.0 when the maximum blend weight has been reached. The minimum of the detail and blend weight scale values is multiplied with the random scale value to determine the final scale. Set this if you want the model to scale up as the material blend fades in. The smaller the value, the smaller the model will start as the material begins to fade in."
	float32 m_flBlendWeightMinScale; // = 1
	// MPropertyFriendlyName = "Min Blend Weight"
	// MPropertyAttributeRange = "0.01 1.0"
	// MPropertyDescription = "Minimum blend weight value for which the model will be placed. If the blend weight value is less than this value, the model will not be placed."
	float32 m_flBlendWeightMin; // = 0.25
	// MPropertyFriendlyName = "Max Blend Weight"
	// MPropertyAttributeRange = "0.01 1.0"
	// MPropertyDescription = "Maximum blend weight value for which the model will be placed. If the blend weight value is more than this value, the model will not be placed."
	float32 m_flBlendWeightMax; // = 1
	// MPropertyFriendlyName = "Full Density Blend Weight"
	// MPropertyAttributeRange = "0.01 1.0"
	// MPropertyDescription = "Blend weight at which the model will be at full density. Must be between the minimum and maximum blend weight values. The density of this model placement will increase with the blend weight value up to this value at which point it will be at full density."
	float32 m_flBlendWeightFullDenstity; // = 0.75
	// MPropertyDescription = "Should instances of this model generate shadows in the lightmap. Note that shadows in the light map will persist even after the model fades out."
	bool m_bCastStaticShadows;
};
