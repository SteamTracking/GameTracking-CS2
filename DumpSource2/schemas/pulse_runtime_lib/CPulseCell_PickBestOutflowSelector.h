// MPropertyFriendlyName = "Select Best Exit"
// MPropertyDescription = "Evaluate the requirements of each connected node"
// MPulseEditorHeaderIcon = "tools/images/pulse_editor/requirements.png"
// MPulseEditorCanvasItemSpecKV3 = "{ className='IsControlFlowNode AllOutflowsInSpecialSection IsSelectorNode' create_special_outflows_section=true }"
// MHasKV3TransferPolymorphicClassname
class CPulseCell_PickBestOutflowSelector : public CPulseCell_BaseFlow
{
	PulseBestOutflowRules_t m_nCheckType; // = "SORT_BY_NUMBER_OF_VALID_CRITERIA"
	PulseSelectorOutflowList_t m_OutflowList;
};
