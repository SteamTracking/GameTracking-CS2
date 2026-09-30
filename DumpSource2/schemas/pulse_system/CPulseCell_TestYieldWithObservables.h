// MHasKV3TransferPolymorphicClassname
class CPulseCell_TestYieldWithObservables : public CPulseCell_BaseYieldingInflow
{
	float32 m_flWatchForFloatValue;
	CPulseObservableExpression< float32 > m_LiveFloatValue; // = { "m_DependentObservableBlackboardReferences": [  ], "m_DependentObservableTempVars": [  ], "m_DependentObservableVars": [  ], "m_EvaluateConnection": { "m_SourceOutflowName": "", "m_nDestChunk": -1, "m_nInstruction": -1 } }
	CUtlString m_WatchForStringValue;
	CPulseObservableExpression< CUtlString > m_LiveStringValue; // = { "m_DependentObservableBlackboardReferences": [  ], "m_DependentObservableTempVars": [  ], "m_DependentObservableVars": [  ], "m_EvaluateConnection": { "m_SourceOutflowName": "", "m_nDestChunk": -1, "m_nInstruction": -1 } }
	CPulse_ResumePoint m_WakeResume; // = { "m_SourceOutflowName": "", "m_nDestChunk": -1, "m_nInstruction": -1 }
};
