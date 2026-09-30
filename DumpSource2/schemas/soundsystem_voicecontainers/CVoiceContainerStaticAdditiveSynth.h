// MPropertyFriendlyName = "Additive Synth Container"
// MPropertyDescription = "This is a static additive synth that can scale components of the synth based on how many instances are running."
// MHasKV3TransferPolymorphicClassname
class CVoiceContainerStaticAdditiveSynth : public CVoiceContainerAsyncGenerator
{
	CUtlVector< CVoiceContainerStaticAdditiveSynth::CTone > m_tones;
};
