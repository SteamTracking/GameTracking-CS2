class ragdoll_t
{
	CUtlVector< ragdollelement_t > list;
	CUtlVector< ragdollhierarchyjoint_t > hierarchyJoints;
	CUtlVector< int32 > boneIndex;
	bool allowStretch;
	bool unused;
};
