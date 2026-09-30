// MPropertyFriendlyName = "VMix Group Box"
// MPropertyDescription = "Groups a set of nodes.  Comments/colors will get displayed in the graph and on node editors.  A group box allows the user to drag the entire group as one object."
// MHasKV3TransferPolymorphicClassname
class CMixGroupBox : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Background Color"
	Color m_color; // = [ 40, 40, 70, 100 ]
	// MPropertyFriendlyName = "Move contained nodes"
	bool m_bMovesNodes; // = true
};
