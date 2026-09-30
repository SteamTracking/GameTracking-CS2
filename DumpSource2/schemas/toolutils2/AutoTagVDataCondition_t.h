class AutoTagVDataCondition_t
{
	// MPropertyDescription = "The VData file to read"
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeCVDataResource > > m_SourceFile;
	// MPropertyDescription = "The key whose value must match the asset name (ie. something like 'm_Model' if you want to apply this tag to .vmdl assets that are referenced by the vdata file)"
	CKV3MemberNameWithStorage m_AssetKey;
	// MPropertyDescription = "Optional second key to check"
	CKV3MemberNameWithStorage m_AlternateAssetKey;
	// MPropertyDescription = "This expression determines whether the tag should actually be applied to an asset
//It will be evaluated against vdata entries where the key matches the asset - if any of them evaluate to true the tag will be applied.
//Most simple expressions involving the VData keys are supported. Use 'true' to tag unconditionally."
	CUtlString m_Expression;
};
