class ChainToSolveData_t
{
	int32 m_nChainIndex; // = -1
	IKSolverSettings_t m_SolverSettings; // = { "m_EndEffectorRotationFixUpMode": "MatchTargetOrientation", "m_SolverType": "IKSOLVER_TwoBone", "m_nNumIterations": 6 }
	IKTargetSettings_t m_TargetSettings; // = { "m_AnimgraphParameterNameOrientation": { "m_id": 0 }, "m_AnimgraphParameterNamePosition": { "m_id": 0 }, "m_Bone": { "m_Name": "" }, "m_TargetCoordSystem": "World Space", "m_TargetSource": "Bone" }
	SolveIKChainAnimNodeDebugSetting m_DebugSetting; // = "SOLVEIKCHAINANIMNODEDEBUGSETTING_None"
	float32 m_flDebugNormalizedValue; // = 1
	VectorAligned m_vDebugOffset;
};
