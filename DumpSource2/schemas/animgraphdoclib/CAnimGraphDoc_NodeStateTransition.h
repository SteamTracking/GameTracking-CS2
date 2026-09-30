// MHasKV3TransferPolymorphicClassname
class CAnimGraphDoc_NodeStateTransition : public CAnimGraphDoc_StateTransition
{
	// MPropertyFriendlyName = "Blend Duration"
	CFloatAnimValue m_blendDuration; // = { "_class": "CFloatAnimValue", "m_eSource": "Constant", "m_flConstValue": 0.2, "m_paramID": { "m_id": 0 }, "m_paramName": "" }
	// MPropertyFriendlyName = "Reset Destination"
	bool m_bReset; // = true
	// MPropertyFriendlyName = "Start Cycle At"
	ResetCycleOption m_resetCycleOption; // = "Beginning"
	// MPropertyFriendlyName = "Fixed Start Cycle Value"
	CFloatAnimValue m_flFixedCycleValue; // = { "_class": "CFloatAnimValue", "m_eSource": "Constant", "m_flConstValue": 0, "m_paramID": { "m_id": 0 }, "m_paramName": "" }
	// MPropertySuppressField
	CBlendCurve m_blendCurve; // = { "m_flControlPoint1": 0, "m_flControlPoint2": 1 }
};
