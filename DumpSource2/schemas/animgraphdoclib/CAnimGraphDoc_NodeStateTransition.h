// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_NodeStateTransition : public CAnimGraphDoc_StateTransition
{
	// MPropertyFriendlyName = "Blend Duration"
	CFloatAnimValue m_blendDuration; // = { "m_flConstValue": 0.2 }
	// MPropertyFriendlyName = "Reset Destination"
	bool m_bReset; // = true
	// MPropertyFriendlyName = "Start Cycle At"
	ResetCycleOption m_resetCycleOption; // = "Beginning"
	// MPropertyFriendlyName = "Fixed Start Cycle Value"
	CFloatAnimValue m_flFixedCycleValue;
	// MPropertySuppressField
	CBlendCurve m_blendCurve;
};
