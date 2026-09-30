class CNmGraphDefinition
{
	CGlobalSymbol m_variationID;
	CStrongHandle< InfoForResourceTypeCNmSkeleton > m_skeleton;
	CUtlVector< CStrongHandle< InfoForResourceTypeCNmSkeleton > > m_supportedSecondarySkeletons;
	CNmGraphVariationUserData* m_pUserData;
	CUtlVector< int16 > m_persistentNodeIndices;
	int16 m_nRootNodeIdx; // = -1
	CUtlVector< CGlobalSymbol > m_controlParameterIDs;
	CUtlVector< CGlobalSymbol > m_virtualParameterIDs;
	CUtlVector< int16 > m_virtualParameterNodeIndices;
	CUtlVector< CNmGraphDefinition::ReferencedGraphSlot_t > m_referencedGraphSlots;
	CUtlVector< CNmGraphDefinition::ExternalGraphSlot_t > m_externalGraphSlots;
	CUtlVector< CNmGraphDefinition::ExternalPoseSlot_t > m_externalPoseSlots;
	CUtlVector< CUtlString > m_nodePaths;
	CUtlVector< CStrongHandleVoid > m_resources;
};
