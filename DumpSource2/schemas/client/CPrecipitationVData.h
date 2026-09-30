// MHasKV3TransferPolymorphicClassname
class CPrecipitationVData : public CEntitySubclassVDataBase
{
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_szParticlePrecipitationEffect;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_szParticlePrecipitationPuddleEffect;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_szParticlePrecipitationPostEffect;
	float32 m_flInnerDistance; // = 32
	ParticleAttachment_t m_nAttachType; // = "PATTACH_ABSORIGIN_FOLLOW"
	bool m_bBatchSameVolumeType; // = true
	int32 m_nRTEnvCP; // = -1
	int32 m_nRTEnvCPComponent;
	CUtlString m_szModifier;
	// MPropertyDescription = "If set, we will populate a snapshot from the surface graph"
	int32 m_nUseSnapshotFromSurfaceGraph; // = -1
	PrecipitationFilter_t m_snapshotFilter; // = { "m_flMaxRadius": 200 }
};
