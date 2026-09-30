// MPropertyElementNameFn
class CompositeMaterialAssemblyProcedure_t
{
	// MPropertyFriendlyName = "Includes"
	CUtlVector< CResourceNameTyped< CWeakHandle< InfoForResourceTypeCCompositeMaterialKit > > > m_vecCompMatIncludes;
	// MPropertyFriendlyName = "Match Filters"
	CUtlVector< CompositeMaterialMatchFilter_t > m_vecMatchFilters;
	// MPropertyFriendlyName = "Composite Inputs"
	CUtlVector< CompositeMaterialInputContainer_t > m_vecCompositeInputContainers;
	// MPropertyFriendlyName = "Property Mutators"
	CUtlVector< CompMatPropertyMutator_t > m_vecPropertyMutators;
};
