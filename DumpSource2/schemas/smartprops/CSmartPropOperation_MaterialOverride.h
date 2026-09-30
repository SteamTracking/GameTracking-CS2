// MPropertyFriendlyName = "Material Override"
// MPropertyDescription = "Specifies a table of material replacements to apply to all following models. Mapping goes from the material specified by the model (including material group selection) to the replacement material. Previous material overrides are not considered when determining the base material."
// MVDataClassGroup = "Material"
// MHasKV3TransferPolymorphicClassname
class CSmartPropOperation_MaterialOverride : public CSmartPropOperation
{
	// MPropertyFriendlyName = "Clear Active Overrides"
	// MPropertyDescription = "If enabled, clear any previous material overrides, so that only the material replacements specified in this table will be active."
	CSmartPropAttributeBool m_bClearCurrentOverrides;
	// MPropertyAutoExpandSelf
	// MPropertyFriendlyName = "Material Replacements"
	// MPropertyDescription = "Table specifying pairs of existing materials and the material to replace them with."
	CUtlVector< CSmartPropMaterialReplacement > m_MaterialReplacements;
};
