// MHasKV3TransferPolymorphicClassname
class C_OP_PlayEndCapWhenFinished : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "play when emission ends"
	bool m_bFireOnEmissionEnd;
	// MPropertyFriendlyName = "wait for children to finish"
	bool m_bIncludeChildren; // = true
};
