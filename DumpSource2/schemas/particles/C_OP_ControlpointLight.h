// MHasKV3TransferPolymorphicClassname
class C_OP_ControlpointLight : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "initial color bias"
	float32 m_flScale;
	// MPropertyFriendlyName = "light 1 control point"
	int32 m_nControlPoint1;
	// MPropertyFriendlyName = "light 2 control point"
	int32 m_nControlPoint2;
	// MPropertyFriendlyName = "light 3 control point"
	int32 m_nControlPoint3;
	// MPropertyFriendlyName = "light 4 control point"
	int32 m_nControlPoint4;
	// MPropertyFriendlyName = "light 1 control point offset"
	Vector m_vecCPOffset1;
	// MPropertyFriendlyName = "light 2 control point offset"
	Vector m_vecCPOffset2;
	// MPropertyFriendlyName = "light 3 control point offset"
	Vector m_vecCPOffset3;
	// MPropertyFriendlyName = "light 4 control point offset"
	Vector m_vecCPOffset4;
	// MPropertyFriendlyName = "light 1 50% distance"
	float32 m_LightFiftyDist1; // = 100
	// MPropertyFriendlyName = "light 1 0% distance"
	float32 m_LightZeroDist1; // = 200
	// MPropertyFriendlyName = "light 2 50% distance"
	float32 m_LightFiftyDist2; // = 100
	// MPropertyFriendlyName = "light 2 0% distance"
	float32 m_LightZeroDist2; // = 200
	// MPropertyFriendlyName = "light 3 50% distance"
	float32 m_LightFiftyDist3; // = 100
	// MPropertyFriendlyName = "light 3 0% distance"
	float32 m_LightZeroDist3; // = 200
	// MPropertyFriendlyName = "light 4 50% distance"
	float32 m_LightFiftyDist4; // = 100
	// MPropertyFriendlyName = "light 4 0% distance"
	float32 m_LightZeroDist4; // = 200
	// MPropertyFriendlyName = "light 1 color"
	Color m_LightColor1;
	// MPropertyFriendlyName = "light 2 color"
	Color m_LightColor2;
	// MPropertyFriendlyName = "light 3 color"
	Color m_LightColor3;
	// MPropertyFriendlyName = "light 4 color"
	Color m_LightColor4;
	// MPropertyFriendlyName = "light 1 type 0=point 1=spot"
	bool m_bLightType1;
	// MPropertyFriendlyName = "light 2 type 0=point 1=spot"
	bool m_bLightType2;
	// MPropertyFriendlyName = "light 3 type 0=point 1=spot"
	bool m_bLightType3;
	// MPropertyFriendlyName = "light 4 type 0=point 1=spot"
	bool m_bLightType4;
	// MPropertyFriendlyName = "light 1 dynamic light"
	bool m_bLightDynamic1;
	// MPropertyFriendlyName = "light 2 dynamic light"
	bool m_bLightDynamic2;
	// MPropertyFriendlyName = "light 3 dynamic light"
	bool m_bLightDynamic3;
	// MPropertyFriendlyName = "light 4 dynamic light"
	bool m_bLightDynamic4;
	// MPropertyFriendlyName = "compute normals from control points"
	bool m_bUseNormal;
	// MPropertyFriendlyName = "half-lambert normals"
	bool m_bUseHLambert; // = true
	// MPropertyFriendlyName = "clamp minimum light value to initial color"
	bool m_bClampLowerRange;
	// MPropertyFriendlyName = "clamp maximum light value to initial color"
	bool m_bClampUpperRange;
};
