class FeAntiTunnelProbeBuild_t
{
	float32 flWeight; // = 1
	float32 flActivationDistance; // = 1
	float32 flBias;
	float32 flCurvature;
	uint32 nFlags;
	uint16 nProbeNode;
	CUtlVector< uint16 > targetNodes;
};
