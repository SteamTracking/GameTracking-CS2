// MVDataRoot
class CNavHullVData
{
	// MPropertyFriendlyName = "Enabled"
	// MPropertyDescription = "Is this agent enabled for generation? ( will result in 0 nav areas for this agent if not )."
	bool m_bAgentEnabled; // = true
	// MPropertyFriendlyName = "Radius"
	// MPropertyDescription = "Radius of navigating agent capsule."
	float32 m_agentRadius; // = 15
	// MPropertyFriendlyName = "Height"
	// MPropertyDescription = "Height of navigating agent capsule."
	float32 m_agentHeight; // = 71
	// MPropertyFriendlyName = "Enable Crouch Height"
	// MPropertyDescription = "Enable shorter navigating agent capsules ( crouch ) in addition to regular height capsules."
	bool m_agentShortHeightEnabled;
	// MPropertyFriendlyName = "Crouch height"
	// MPropertyDescription = "Crouch height of navigating agent capsules if enabled."
	float32 m_agentShortHeight; // = 35.5
	// MPropertyFriendlyName = "Enable Crawl Height"
	// MPropertyDescription = "Enable even shorter navigating agent capsules ( crawl ) in addition to regular height capsules."
	bool m_agentCrawlEnabled;
	// MPropertyFriendlyName = "Crawl height"
	// MPropertyDescription = "Crawl height of navigating agent capsules if enabled."
	float32 m_agentCrawlHeight; // = 17.5
	// MPropertyFriendlyName = "Max Climb"
	// MPropertyDescription = "Max vertical offset that the agent simply ignores and walks over."
	float32 m_agentMaxClimb; // = 17.5
	// MPropertyFriendlyName = "Max Slope"
	// MPropertyDescription = "Max ground slope to be considered walkable."
	int32 m_agentMaxSlope; // = 50
	// MPropertyFriendlyName = "Max Jump Down Distance"
	// MPropertyDescription = "Max vertical offset at which to create a jump connection ( possibly one-way )."
	float32 m_agentMaxJumpDownDist; // = 240
	// MPropertyFriendlyName = "Max Horizontal Jump Distance"
	// MPropertyDescription = "Max horizontal offset over which to create a jump connection ( actually a parameter into the true threshold function )."
	float32 m_agentMaxJumpHorizDistBase; // = 64
	// MPropertyFriendlyName = "Max Jump Up Distance"
	// MPropertyDescription = "Max vertical offset at which to make a jump connection two-way."
	float32 m_agentMaxJumpUpDist;
	// MPropertyFriendlyName = "Border Erosion"
	// MPropertyDescription = "Border erosion in voxel units ( -1 to use default value based on agent radius )."
	int32 m_agentBorderErosion; // = -1
	// MPropertyFriendlyName = "Hierarchical Nav"
	// MPropertyDescription = "Enables super node nav information to be generated"
	bool m_flowMapGenerationEnabled;
	// MPropertyFriendlyName = "Hierarchical Nav Max Super Node radius"
	// MPropertyDescription = "Maximum radius of a super node - larger means lower resolution"
	float32 m_flowMapNodeMaxRadius; // = 400
};
