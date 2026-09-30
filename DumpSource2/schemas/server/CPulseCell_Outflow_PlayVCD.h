// MHasKV3TransferPolymorphicClassname
class CPulseCell_Outflow_PlayVCD : public CPulseCell_Outflow_PlayVCDBase
{
	CStrongHandle< InfoForResourceTypeCChoreoSceneResource > m_hChoreoScene;
	CPulse_OutflowConnection m_OnPaused; // = { "m_SourceOutflowName": "", "m_nDestChunk": -1, "m_nInstruction": -1 }
	CPulse_OutflowConnection m_OnResumed; // = { "m_SourceOutflowName": "", "m_nDestChunk": -1, "m_nInstruction": -1 }
	CUtlVector< CPulseCell_Outflow_PlayVCD::VCDRequirementInfo_t > m_OutRequirements;
};
