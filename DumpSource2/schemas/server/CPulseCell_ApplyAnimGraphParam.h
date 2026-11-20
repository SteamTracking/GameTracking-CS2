// MPropertyFriendlyName = "Apply a graph param onto an entity"
// MPropertyDescription = "Sets a graph param and updates it every tick, as long as the cursor is active on this node"
// MHasKV3TransferPolymorphicClassname
class CPulseCell_ApplyAnimGraphParam : public CPulseCell_BaseYieldingInflow
{
	CPulseObservableExpression< CPulseVariant > m_value; // = { "m_EvaluateConnection": { "m_nDestChunk": -1, "m_nInstruction": -1 } }
};
