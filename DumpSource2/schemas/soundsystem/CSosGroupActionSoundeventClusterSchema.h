// MPropertyFriendlyName = "Soundevent Cluster"
// MHasKV3TransferPolymorphicClassname
class CSosGroupActionSoundeventClusterSchema : public CSosGroupActionSchema
{
	// MPropertyFriendlyName = "Minimum Nearby Soundevents"
	int32 m_nMinNearby; // = 6
	// MPropertyFriendlyName = "Search Radius to Cluster Soundevents"
	float32 m_flClusterEpsilon; // = 36
	// MPropertyFriendlyName = "'Should Play' Opvar Name"
	CUtlString m_shouldPlayOpvar; // = "cluster_should_play"
	// MPropertyFriendlyName = "'Should Play Cluster Child' Opvar Name"
	CUtlString m_shouldPlayClusterChild; // = "cluster_should_play_child"
	// MPropertyFriendlyName = "Cluster Size Opvar Name"
	CUtlString m_clusterSizeOpvar; // = "cluster_size"
	// MPropertyFriendlyName = "'Group Box Mins' Opvar Name"
	CUtlString m_groupBoundingBoxMinsOpvar; // = "cluster_group_box_mins"
	// MPropertyFriendlyName = "'Group Box Maxs' Opvar Name"
	CUtlString m_groupBoundingBoxMaxsOpvar; // = "cluster_group_box_maxs"
};
