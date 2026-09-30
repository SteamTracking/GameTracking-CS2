// MPropertyFriendlyName = "VMix Subgraph Switch Audio Node"
// MPropertyDescription = "Allows you to swap between sub-graphs with a short crossfade.  Can be used to swap out processing algorithms/configurations, or to dynamically enable/disable optional processing stages.  This can also expose control parameters from the subgraphs so those can be connected to the outer graph."
// MHasKV3TransferPolymorphicClassname
class CMixSubgraphSwitch : public CMixPropertyBase
{
	// MPropertyFriendlyName = "Show Detailed Plug Names"
	bool bUseDetailedPlugNames;
	// MPropertyFriendlyName = "Default Subgraph"
	CSelectableSubgraph defaultSubgraph; // = { "_class": "CSelectableSubgraph", "file": "soundstacks/subgraph_default.vmix", "subgraphName": "" }
	// MPropertyFriendlyName = "Mode"
	// MPropertyGroupName = "+Transition Behavior"
	VMixSubgraphSwitchInterpolationType_t interpolationMode; // = "SUBGRAPH_INTERPOLATION_TEMPORAL_CROSSFADE"
	// MPropertyFriendlyName = "Only Let Effect Ring On Fadeout"
	// MPropertyGroupName = "Transition Behavior"
	bool bOnlyTailsOnFadeOut;
	// MPropertyFriendlyName = "Transition time (seconds)"
	// MPropertyGroupName = "Transition Behavior"
	float32 flTransitionTime; // = 0.5
	// MPropertyFriendlyName = "Channels"
	// MPropertyAttributeChoiceName = "processor_channels"
	int32 nChannels; // = -1
	CUtlVector< CSelectableSubgraph > subgraphs;
};
