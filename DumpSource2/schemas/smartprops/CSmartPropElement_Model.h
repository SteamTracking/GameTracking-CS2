// MPropertyFriendlyName = "Model"
// MPropertyDescription = "Places a model as the child of an element."
// MVDataOutlinerAssetNameExpr = "m_sModelName"
// MHasKV3TransferPolymorphicClassname
class CSmartPropElement_Model : public CSmartPropElement
{
	// MPropertyDescription = "Name of the model resource (.vmdl) to place."
	// MPropertyProvidesEditContextString = "ToolEditContext_ID_VMDL"
	CSmartPropAttributeModelName m_sModelName;
	// MPropertyFriendlyName = "Material Group"
	// MPropertyDescription = "Specifies the name of the material group (skin) to use when displaying the specified model."
	CSmartPropAttributeMaterialGroup m_MaterialGroupName;
	// MPropertyDescription = "If enabled the model will be rendered as a detail object, which is faster for placing many small objects and has fade out functionality, but may have different lighting characteristics. Detail object models support only uniform scale and will use the largest component of the scale value."
	CSmartPropAttributeBool m_bDetailObject;
	// MPropertySuppressExpr = "m_bDetailObject == true"
	// MPropertyDescription = "Scale factor (may be non-uniform) to be applied directly to the model (in the model's local space)."
	CSmartPropAttributeVector m_vModelScale; // = [ 1, 1, 1 ]
	// MPropertyFriendlyName = "Model Scale"
	// MPropertySuppressExpr = "m_bDetailObject == false"
	// MPropertyDescription = "Uniform scale to be applied to the model, certain properties like detail object mean only uniform scale may be applied to the model."
	CSmartPropAttributeFloat m_flUniformModelScale; // = 1
	// MPropertyAttributeEditor = "SmartPropAttributeEditor( LODLevel )"
	// MPropertySuppressExpr = "m_bDetailObject == true"
	// MPropertyDescription = "Select model LOD level. The default Auto LOD means the lod will be picked based on the size of the model on screen. If a specific level is selected, then that lod level will always be used regardless of the size of the model on screen."
	CSmartPropAttributeInt m_nLodLevel; // = -1
	// MPropertyFriendlyName = "Override Surface Property"
	// MPropertySuppressExpr = "m_bDetailObject == true"
	// MPropertyDescription = "If non-empty, specifies the name of a surface property to use for all physics shapes of the specified model, overriding any surface properties specified within the model."
	CSmartPropAttributeSurfaceProperty m_SurfacePropertyOverride;
	// MPropertyFriendlyName = "Fade Level"
	// MPropertySuppressExpr = "m_bDetailObject == false"
	// MPropertyDescription = "Controls the size at which a model marked as a detail object will fade out."
	SmartPropDetailFadeLevel_t m_nDetailObjectFadeLevel; // = "NORMAL"
	// MPropertyFriendlyName = "Cast Shadows"
	// MPropertyDescription = "Should the model cast shadows."
	CSmartPropAttributeBool m_bCastShadows; // = true
	// MPropertyFriendlyName = "Rigid Deformation Only"
	// MPropertySuppressExpr = "m_bDetailObject == true"
	// MPropertyDescription = "If enabled, only the transform of the model will be modified by any active deformer, the vertices of the model will not be changed by the deformer."
	CSmartPropAttributeBool m_bRigidDeformation;
	// MPropertyFriendlyName = "Disable Dynamic Deformable"
	// MPropertySuppressExpr = "m_bDetailObject == true"
	// MPropertyDescription = "If checked, this model will not deform in game when the smart prop is placed inside a dynamic deformable entity (such as func_deformable_brush)."
	CSmartPropAttributeBool m_bDisableDynamicDeformable;
};
