// MPropertyElementNameFn
// MHasKV3TransferPolymorphicClassname
class CSolveIKChainAnimNodeChainData
{
	// MPropertyFriendlyName = "IK Chain"
	// MPropertyAttributeChoiceName = "IKChain"
	CUtlString m_IkChain;
	// MPropertyFriendlyName = "Solver Setting Source"
	// MPropertyAutoRebuildOnChange
	SolveIKChainAnimNodeSettingSource m_SolverSettingSource; // = "SOLVEIKCHAINANIMNODESETTINGSOURCE_Default"
	// MPropertyFriendlyName = "Override Solver Settings"
	// MPropertyAutoExpandSelf
	// MPropertyAttrStateCallback
	IKSolverSettings_t m_OverrideSolverSettings; // = { "m_EndEffectorRotationFixUpMode": "MatchTargetOrientation", "m_SolverType": "IKSOLVER_TwoBone", "m_nNumIterations": 6 }
	// MPropertyFriendlyName = "Target Setting Source"
	// MPropertyAutoRebuildOnChange
	SolveIKChainAnimNodeSettingSource m_TargetSettingSource; // = "SOLVEIKCHAINANIMNODESETTINGSOURCE_Default"
	// MPropertyFriendlyName = "Override Target Settings"
	// MPropertyAutoExpandSelf
	// MPropertyAttrStateCallback
	IKTargetSettings_t m_OverrideTargetSettings; // = { "m_AnimgraphParameterNameOrientation": { "m_id": 0 }, "m_AnimgraphParameterNamePosition": { "m_id": 0 }, "m_Bone": { "m_Name": "" }, "m_TargetCoordSystem": "World Space", "m_TargetSource": "Bone" }
	// MPropertyFriendlyName = "Debug Setting"
	// MPropertyGroupName = "Debug"
	SolveIKChainAnimNodeDebugSetting m_DebugSetting; // = "SOLVEIKCHAINANIMNODEDEBUGSETTING_None"
	// MPropertyFriendlyName = "Debug Normalized Length"
	// MPropertyGroupName = "Debug"
	float32 m_flDebugNormalizedLength; // = 1
	// MPropertyFriendlyName = "Debug Offset"
	// MPropertyGroupName = "Debug"
	Vector m_vDebugOffset;
};
