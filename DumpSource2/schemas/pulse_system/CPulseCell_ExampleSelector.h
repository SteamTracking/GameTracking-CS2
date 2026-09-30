// MPropertyFriendlyName = "Select Example Criteria"
// MPropertyDescription = "Evaluate the requirements of each connected node"
// MPulseEditorHeaderIcon = "tools/images/pulse_editor/requirements.png"
// MPulseEditorCanvasItemSpecKV3 = "{ className='IsControlFlowNode AllOutflowsInSpecialSection IsSelectorNode' create_special_outflows_section=true }"
// MHasKV3TransferPolymorphicClassname
class CPulseCell_ExampleSelector : public CPulseCell_BaseFlow
{
	PulseSelectorOutflowList_t m_OutflowList;
};
