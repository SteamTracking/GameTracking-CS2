// MPropertyFriendlyName = "Smart Prop Reference"
// MPropertyDescription = "Evaluates a specified smart prop as a child of the current element."
// MVDataOutlinerAssetNameExpr = "m_sSmartProp"
// MHasKV3TransferPolymorphicClassname
class CSmartPropElement_SmartProp : public CSmartPropElement
{
	// MPropertyDescription = "Name of the target smart prop resource (.vsmart) to evaluate."
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeISmartProp > > m_sSmartProp;
	// MPropertyDescription = "If enabled, any changes made to the evaluation state by the target smart prop (as well as modifiers) will only apply locally and will not affect the evaluation state of the parent. Disabling this will allow modifications to the evaluation state by the referenced smart prop to apply the current state of the of the parent. For example if the referenced smart prop applies a transform and you want the transform to affect the elements in the parent after this element, then you should disable local evaluation state."
	bool m_bLocalEvaluationState; // = true
};
