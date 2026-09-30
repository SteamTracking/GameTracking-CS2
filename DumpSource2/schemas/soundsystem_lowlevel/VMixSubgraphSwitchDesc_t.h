class VMixSubgraphSwitchDesc_t
{
	CUtlString m_name;
	CUtlString m_effectName;
	CUtlVector< CUtlString > m_subgraphs;
	VMixSubgraphSwitchInterpolationType_t m_interpolationMode; // = "SUBGRAPH_INTERPOLATION_TEMPORAL_CROSSFADE"
	bool m_bOnlyTailsOnFadeOut;
	float32 m_flInterpolationTime;
};
