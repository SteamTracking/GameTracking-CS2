// MHasKV3TransferPolymorphicClassname
class CNavPathCost : public INavPathCost
{
	bool m_bAllowLadders; // = true
	bool m_bCanFly;
	bool m_bCanSwim;
	float32 m_flWaterToGroundMaxHeight; // = 100
	float32 m_flGroundToWaterMaxHeight; // = 100
	float32 m_flGroundToWaterTransitionDistance; // = -1
	float32 m_flWaterToGroundTransitionDistance; // = -1
	float32 m_flFlyingTransitionTolerance; // = 140
	bool m_bOptimizeFlySpacePathfinds; // = true
	bool m_bStringPullFlySpacePathfinds;
	bool m_bSupportsTransitions;
	float32 m_flTransitionPenalty; // = 200
};
