// MHasKV3TransferPolymorphicClassname
class C_OP_RenderPostProcessing : public CParticleFunctionRenderer
{
	// MPropertyFriendlyName = "Post Processing Strength"
	CPerParticleFloatInput m_flPostProcessStrength; // = { "m_flLiteralValue": 1 }
	// MPropertyFriendlyName = "Post Processing File"
	// MPropertyAttributeEditor = "AssetBrowse( vpost, *showassetpreview )"
	CStrongHandle< InfoForResourceTypeCPostProcessingResource > m_hPostTexture;
	// MPropertyFriendlyName = "Post Processing Priority Group"
	ParticlePostProcessPriorityGroup_t m_nPriority; // = "PARTICLE_POST_PROCESS_PRIORITY_GAMEPLAY_EFFECT"
};
