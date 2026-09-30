// MHasKV3TransferPolymorphicClassname
class C_OP_CPOffsetToPercentageBetweenCPs : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "percentage minimum"
	float32 m_flInputMin;
	// MPropertyFriendlyName = "percentage maximum"
	float32 m_flInputMax; // = 1
	// MPropertyFriendlyName = "percentage bias"
	float32 m_flInputBias; // = 0.5
	// MPropertyFriendlyName = "starting control point"
	int32 m_nStartCP;
	// MPropertyFriendlyName = "ending control point"
	int32 m_nEndCP; // = 1
	// MPropertyFriendlyName = "offset control point"
	int32 m_nOffsetCP; // = 2
	// MPropertyFriendlyName = "output control point"
	int32 m_nOuputCP; // = 4
	// MPropertyFriendlyName = "input control point"
	int32 m_nInputCP; // = 3
	// MPropertyFriendlyName = "treat distance between points as radius"
	bool m_bRadialCheck; // = true
	// MPropertyFriendlyName = "treat offset as scale of total distance"
	bool m_bScaleOffset;
	// MPropertyFriendlyName = "offset amount"
	// MVectorIsCoordinate
	Vector m_vecOffset;
};
