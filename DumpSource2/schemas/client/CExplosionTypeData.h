// MVDataRoot
// MVDataOverlayType = 1
// MVDataAssociatedFile = "scripts/explosion_types.vdata"
class CExplosionTypeData
{
	CSoundEventName m_SoundName;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_ParticleEffect;
	// MPropertyDescription = "Whether this explosion relates to fire"
	bool m_bIsIncindiary;
	// MPropertyDescription = "Whether this explosion has explosive forces"
	bool m_bHasForces;
	// MPropertyDescription = "Decal to use when this explosion occurs"
	CGlobalSymbol m_DecalType; // = "Scorch"
};
